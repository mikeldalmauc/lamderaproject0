module Frontend exposing (..)

import Browser exposing (UrlRequest(..))
import Browser.Navigation as Nav
import Html
import Html.Attributes as Attr
import Lamdera
import Types exposing (..)
import Url

-- Elm ui imports
import Element exposing (Element, el, text, column, row, alignRight, fill, width, rgb255, spacing, centerY, padding)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import String exposing (padLeft)
import Html.Attributes exposing (height)

type alias Model =
    FrontendModel


app =
    Lamdera.frontend
        { init = init
        , onUrlRequest = UrlClicked
        , onUrlChange = UrlChanged
        , update = update
        , updateFromBackend = updateFromBackend
        , subscriptions = \m -> Sub.none
        , view = view
        }


init : Url.Url -> Nav.Key -> ( Model, Cmd FrontendMsg )
init url key =
    ( { key = key
      , message = "Welcome to Lamdera! You're looking at the auto-generated base implementation. Check out src/Frontend.elm to start coding!"
      , question = {question = "Lorem ex magna incididunt aute exercitation occaecat deserunt excepteur ullamco elit.a", options = 
        ["Consectetur in nulla proident dolore sunt veniam voluptate adipisicing id ullamco officia incididunt Lorem."
        , "Fugiat incididunt deserunt esse aliqua et cupidatat et consequat ut mollit sunt."
        , "Enim aliqua sit aliquip et occaecat minim cupidatat."
        , "Adipisicing cupidatat labore amet nulla ea."]
      }
      }
    , Cmd.none
    )


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
            Element.layout []
            <|  row []
                    [ el [] Element.none
                    , column [width fill, centerY, spacing 30, Element.padding 40]
                        [
                        viewQuestion model.question.question
                        , viewOptions model.question.options
                        ]
                    , el [] Element.none
                    ]
        ]
    }
viewQuestion : String -> Element msg
viewQuestion question = 
    el [] (text question)


viewOptions : List String -> Element msg
viewOptions options = 
    column
        [width fill, centerY, spacing 30]
        <| List.map2 
            (\l op ->  el [ Border.rounded 3 , padding 30 ]  (text <| l ++ ") " ++ op)
            ) 
            ["a", "b", "c", "d"]
            options