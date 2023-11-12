module Types exposing (..)

import Browser exposing (UrlRequest)
import Browser.Navigation exposing (Key)
import Url exposing (Url)
import Crate
import Gamepad.Advanced as GpadAdvanced exposing (Blob, UserMappings)
import Gamepad.Private exposing (Origin)

import Keyboard.Event exposing (KeyboardEvent, decodeKeyboardEvent)
import Keyboard.Key as Key

type alias FrontendModel =
    { key : Key
    , crate : Crate.Model
    , gamepadState : GamepadState
    , userMappings : UserMappings
    , freq : Float
    , delay : Float
    , muted : Bool
    , gain : Float
    }

type GamepadState
    = Initializing
    | DisplayingGamepads Blob
    | RemappingTool GpadAdvanced.Model


type alias BackendModel =
    { message : String
    }

type FrontendMsg
    = UrlClicked UrlRequest
    | UrlChanged Url
    | CrateMsg Crate.Msg

    -- Gamepad messages
    | OnAnimationFrame Blob
    | OnRemappingToolMsg GpadAdvanced.Msg
    | OnToggleRemap
    | NoOpFrontendMsg

    | HandleKeyboardEvent KeyboardEvent

    | ToggleAudio
    | UpdateFreq Float
    | UpdateGain Float

type ToBackend
    = NoOpToBackend


type BackendMsg
    = NoOpBackendMsg


type ToFrontend
    = NoOpToFrontend