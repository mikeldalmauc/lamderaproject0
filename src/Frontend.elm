module Frontend exposing (..)

import PkgPorts exposing (ports)

import Crate exposing (..)

import Browser exposing (UrlRequest(..))
import Browser.Navigation as Nav
import Html exposing (Html, div, li, ul)
import Html.Attributes as Attr
import Lamdera
import Types exposing (..)
import Url 
import Json.Encode

-- Elm ui imports
import Element exposing (Element, el, text, centerY)
import Html.Attributes exposing (style)
import Element exposing (centerX)
import Element.Input as EInput
import Element.Background as EBackground

-- Gamepad
import Gamepad exposing (Gamepad)
import Gamepad.Advanced exposing (Blob, UserMappings)
import Html.Events

-- Keyboard
import Keyboard.Event exposing (KeyboardEvent, decodeKeyboardEvent)
import Keyboard.Key as Key

-- Audio
import WebAudio exposing (oscillator, delay, audioDestination)
import WebAudio.Property exposing (frequency, delayTime )
import String exposing (toFloat)


type alias Model =
    FrontendModel

app =
    Lamdera.frontend
        { init = init
        , onUrlRequest = UrlClicked
        , onUrlChange = UrlChanged
        , update =  
            \msg model ->
                let 
                    ( mod, cmd ) = update msg model 
                in
                ( mod
                , Cmd.batch 
                    [ cmd
                    , audio mod 
                        |> Json.Encode.list WebAudio.encode
                        |> ports.toWebAudio
                    ]
                ) 
        , updateFromBackend = updateFromBackend
        , subscriptions = subscriptions 
        , view = view
        }

type alias PkgPorts ports msg =
    { ports | 
      saveToLocalStorage : String -> Cmd msg 
    , onBlob :  (Blob -> msg) -> Sub msg
    , toWebAudio : Json.Encode.Value -> Cmd msg
    }


subscriptions : Model -> Sub FrontendMsg
subscriptions model =
    Sub.batch 
        [ Sub.map CrateMsg (Crate.subscriptions model.crate)
        , gamePadSubscription model]


gamePadSubscription : Model -> Sub FrontendMsg
gamePadSubscription model =
    case model.gamepadState of
        RemappingTool _ ->
            ports.onBlob (Gamepad.Advanced.onBlob >> OnRemappingToolMsg)

        _ ->
            ports.onBlob OnAnimationFrame


init : Url.Url -> Nav.Key -> ( Model, Cmd FrontendMsg )
init url key =
    let
        (crateModel, crateMsg) = Crate.init  
    in
        ( 
            { key = key
            , crate = crateModel
            , gamepadState = Initializing
            , userMappings = Gamepad.Advanced.emptyUserMappings
            , delay = 0
            , freq = 40
            , gain = 0
            , muted = True
            }
            , Cmd.map CrateMsg crateMsg
        )

noCmd : Model -> ( Model, Cmd msg )
noCmd model =
    ( model, Cmd.none )
    
update : FrontendMsg -> Model -> ( Model, Cmd FrontendMsg )
update msg model =
    case msg of
        UrlClicked urlRequest ->
            case urlRequest of
                Internal url ->
                    ( model
                    , Nav.pushUrl model.key (Url.toString url)
                    )

                External url ->
                    ( model
                    , Nav.load url
                    )

        UrlChanged url ->
            ( model, Cmd.none )

        CrateMsg crateMsg -> 
            let
                (crateModel, crateCmd) = Crate.update crateMsg model.crate
            in
                ( { model | crate = crateModel }, Cmd.map CrateMsg crateCmd)

        OnRemappingToolMsg remapMsg ->
            case model.gamepadState of
                RemappingTool remapModel ->
                    updateOnRemapMsg remapMsg remapModel model

                _ ->
                    noCmd model

        -- Gamepad messages
        OnAnimationFrame blob ->
            noCmd { model | gamepadState = DisplayingGamepads blob }

        OnToggleRemap ->
            noCmd
                { model
                    | gamepadState =
                        case model.gamepadState of
                            RemappingTool _ ->
                                Initializing

                            _ ->
                                RemappingTool (Gamepad.Advanced.init controlsToMap)
                }

                  
        HandleKeyboardEvent event ->
            case event.keyCode of
                Key.Right ->  
                    noCmd model
                Key.Left ->  
                    noCmd model
                Key.Up -> 
                    noCmd model
                Key.Down ->  
                    noCmd model
                Key.Z -> 
                    noCmd model
                Key.Spacebar -> 
                    noCmd model
                Key.C -> 
                    noCmd model 
                Key.Escape ->
                    noCmd model 
                Key.Enter ->
                    noCmd model 
                _ ->
                    noCmd model 
                            
        ToggleAudio -> 
            ({ model | muted = not model.muted }, Cmd.none)

        UpdateFreq freq -> 
            ({ model | freq = freq }, Cmd.none)
        
        UpdateGain gain -> 
            ({ model | gain = gain }, Cmd.none)

        NoOpFrontendMsg ->
            ( model, Cmd.none )


updateFromBackend : ToFrontend -> Model -> ( Model, Cmd FrontendMsg )
updateFromBackend msg model =
    case msg of
        NoOpToFrontend ->
            ( model, Cmd.none )


view : Model -> Browser.Document FrontendMsg
view model =
    { title = ""
    , body =
        [
        --    Html.node "div" [Attr.id "v3d-container"] []
        -- ,  Html.node "script" [Attr.src "/my_app.js"] []
            Element.layout [centerY, centerX]
            <|  viewCrate model.crate
        , gamepadTestView model
        ,  Element.layout [centerY, centerX] 
            <|  Element.column []
                [ EInput.button
                    [ EBackground.color <| Element.rgb255 238 238 238
                    , Element.focused
                        [ EBackground.color <| Element.rgb255 238 180 138 ]
                    , Element.width <| Element.px 200
                    ]
                    { onPress = Just ToggleAudio
                    , label = text "Toggle Audio"
                    }
                , EInput.text 
                    []
                    { onChange = \s -> UpdateFreq <| Maybe.withDefault 440 <| String.toFloat s
                    , text = String.fromFloat model.freq
                    , placeholder = Nothing
                    , label = EInput.labelAbove [] <| text "oscilator frequency"
                    }
                 , EInput.text 
                    []
                    { onChange = \s -> UpdateGain <| Maybe.withDefault 0 <| String.toFloat s
                    , text = String.fromFloat model.gain
                    , placeholder = Nothing
                    , label = EInput.labelAbove [] <| text "gain"
                    }
                ]
        ]
    }

viewScene : Model -> Html.Html FrontendMsg 
viewScene model = 
    Html.div [Attr.id "v3d-container"] []

viewCrate : Crate.Model -> Element FrontendMsg
viewCrate model = 
    el [centerY, centerX] <| Element.html  <|  Html.map CrateMsg <| Crate.view model


{- Gamepad 
-}

updateOnRemapMsg : Gamepad.Advanced.Msg -> Gamepad.Advanced.Model -> Model -> ( Model, Cmd FrontendMsg )
updateOnRemapMsg remapMsg remapModelOld model =
    let
        ( remapModelNew, maybeUpdateUserMappings ) =
            Gamepad.Advanced.update remapMsg remapModelOld
    in
    updateOnMappings maybeUpdateUserMappings { model | gamepadState = RemappingTool remapModelNew }


updateOnMappings : Maybe (UserMappings -> UserMappings) -> Model -> ( Model, Cmd a )
updateOnMappings maybeUpdateUserMappings model =
    case maybeUpdateUserMappings of
        -- Gamepad.Advanced.update didn't provide any function to update user mappings
        Nothing ->
            noCmd model

        -- Gamepad.Advanced.update gave us a function to update user mappings, let's do it!
        Just updateMappings ->
            let
                newUserMappings =
                    updateMappings model.userMappings

                newModel =
                    { model | userMappings = newUserMappings }

                cmd =
                    if newUserMappings == model.userMappings then
                        -- userMappings didn't change in any meaningful way,
                        -- no need to change the URL.
                        Cmd.none
                    else
                        -- userMappings changed, let's "save" it in the URL!
                        Nav.pushUrl
                            model.key
                            ("#" ++ userMappingsToUrlFragment newUserMappings)
            in
            ( newModel, cmd )



allMappableControls : List ( String, Gamepad.Digital )
allMappableControls =
    [ ( "Button A / Cross", Gamepad.A )
    , ( "Button B / Circle", Gamepad.B )
    , ( "Button X / Square", Gamepad.X )
    , ( "Button Y / Triangle", Gamepad.Y )
    , ( "Button Start", Gamepad.Start )
    , ( "Button Back / Select", Gamepad.Back )
    , ( "Logo / Home / Guide", Gamepad.Home )
    , ( "Left Stick: Push Left", Gamepad.LeftStickLeft )
    , ( "Left Stick: Push Right", Gamepad.LeftStickRight )
    , ( "Left Stick: Push Up", Gamepad.LeftStickUp )
    , ( "Left Stick: Push Down", Gamepad.LeftStickDown )
    , ( "Left Stick: Click", Gamepad.LeftStickPress )
    , ( "Left Bumper Button", Gamepad.LeftBumper )
    , ( "Left Trigger / Left Analog Lever", Gamepad.LeftTrigger )
    , ( "Right Stick: Push Left", Gamepad.RightStickLeft )
    , ( "Right Stick: Push Right", Gamepad.RightStickRight )
    , ( "Right Stick: Push Up", Gamepad.RightStickUp )
    , ( "Right Stick: Push Down", Gamepad.RightStickDown )
    , ( "Right Stick: Click", Gamepad.RightStickPress )
    , ( "Right Bumper Button", Gamepad.RightBumper )
    , ( "Right Trigger / Right Analog Lever", Gamepad.RightTrigger )
    , ( "Directional Pad Up", Gamepad.DpadUp )
    , ( "Directional Pad Down", Gamepad.DpadDown )
    , ( "Directional Pad Left", Gamepad.DpadLeft )
    , ( "Directional Pad Right", Gamepad.DpadRight )
    ]


controlsToMap : List ( String, Gamepad.Digital )
controlsToMap =
    allMappableControls


-- URL shenanigans


userMappingsToUrlFragment : UserMappings -> String
userMappingsToUrlFragment userMappings =
    userMappings
        |> Gamepad.Advanced.userMappingsToString
        |> Url.percentEncode


{-| Decode the user mappings from the URL.

If the URL is invalid for any reason, also provide a new Url.

-}
userMappingsFromUrl : Url.Url -> ( UserMappings, Maybe  Url.Url )
userMappingsFromUrl url =
    let
        fragmentCurrent =
            Maybe.withDefault "" url.fragment

        userMappings =
            fragmentCurrent
                |> Url.percentDecode
                |> Maybe.withDefault ""
                |> Gamepad.Advanced.userMappingsFromString
                |> Result.withDefault Gamepad.Advanced.emptyUserMappings

        fragmentUpdated =
            userMappingsToUrlFragment userMappings

        -- If the Url had an invalid fragment, we want to update it with a valid one!
        maybeNewUrl =
            if fragmentCurrent == fragmentUpdated then
                Nothing
            else
                Just { url | fragment = Just fragmentUpdated }
    in
    ( userMappings, maybeNewUrl )


-- view


boolToString : Bool -> String
boolToString bool =
    case bool of
        True ->
            "True"

        False ->
            "False"


toString : Float -> String
toString =
    String.fromFloat >> String.left 7


recordToString : { x : Float, y : Float } -> String
recordToString { x, y } =
    "{ x: " ++ toString x ++ ", y: " ++ toString y ++ " }"


dpadToString : { x : Int, y : Int } -> String
dpadToString { x, y } =
    String.fromInt x ++ "," ++ String.fromInt y


viewDigital : Gamepad -> ( String, Gamepad.Digital ) -> Html msg
viewDigital gamepad ( name, digital ) =
    li
        []
        [ boolToString (Gamepad.isPressed gamepad digital) ++ " <- " ++ name |> Html.text ]


viewAnalog : String -> Html msg
viewAnalog string =
    li [] [ Html.text string ]


viewGamepad : Gamepad -> Html FrontendMsg
viewGamepad gamepad =
    div
        [ style "min-width" "22em" ]
        [ Html.h3
            []
            [ "Gamepad " ++ String.fromInt (Gamepad.getIndex gamepad) |> Html.text ]
        , allMappableControls
            |> List.map (viewDigital gamepad)
            |> ul []
        , [ "Left Stick postion: " ++ recordToString (Gamepad.leftStickPosition gamepad)
          , "Right Stick position: " ++ recordToString (Gamepad.rightStickPosition gamepad)
          , "Dpad position: " ++ dpadToString (Gamepad.dpadPosition gamepad)
          , "Left Trigger (analog)) :" ++ String.fromFloat (Gamepad.value gamepad Gamepad.LeftTriggerAnalog)
          , "Right Trigger (analog)) :" ++ String.fromFloat (Gamepad.value gamepad Gamepad.RightTriggerAnalog)
          ]
            |> List.map viewAnalog
            |> ul []
        ]


viewGamepads : Model -> Blob -> Html FrontendMsg
viewGamepads model blob =
    let
        views =
            List.map viewGamepad <| Gamepad.Advanced.getGamepads controlsToMap model.userMappings blob
    in
    if List.length views > 0 then
        div
            [ style "display" "flex"
            ]
            views
    else
        div
            [ style "display" "flex"
            , style "flex-direction" "column"
            , style "align-items" "center"
            , style "border" "1px solid black"
            , style "padding" "16px"
            ]
            [ div [] [ Html.text "Can't find any gamepad! =(" ]
            , div [] [ Html.text "(The browser won't tell me they are there unless you press some button first, so maybe try that)" ]
            ]


gamepadTestView : Model -> Html FrontendMsg
gamepadTestView model =
    div
        [ style "display" "flex"
        , style "justify-content" "center"
        , style "padding" "16px"
        ]
        [ case model.gamepadState of
            Initializing ->
                Html.text "Awaiting gamepad blob"

            RemappingTool remapModel ->
                div
                    []
                    [ Gamepad.Advanced.view model.userMappings remapModel |> Html.map OnRemappingToolMsg
                    , div [] []
                    , div [] []
                    , Html.button
                        [ Html.Events.onClick OnToggleRemap ]
                        [ Html.text "Close Remap Tool" ]
                    ]

            DisplayingGamepads blob ->
                div
                    []
                    [ div [] []
                    , Html.button
                        [ Html.Events.onClick OnToggleRemap ]
                        [ Html.text "Open Remap Tool" ]
                    , div
                        []
                        [ viewGamepads model blob
                        ]
                    ]
        ]
    

-- Audio

audio : Model -> List WebAudio.Node
audio model =
    if model.muted then 
        []
    else
        [ WebAudio.oscillator 
            [ WebAudio.Property.frequency model.freq ]
            [ WebAudio.audioDestination
            , WebAudio.gain
                [ WebAudio.Property.gain model.gain]
                [ WebAudio.audioDestination ]
            , WebAudio.delay
                [ WebAudio.Property.delayTime model.delay ]
                [ WebAudio.audioDestination ]
            ]
        ]