module Evergreen.V1.Types exposing (..)

import Browser
import Browser.Navigation
import Evergreen.V1.Crate
import Evergreen.V1.Gamepad.Advanced
import Url


type GamepadState
    = Initializing
    | DisplayingGamepads Evergreen.V1.Gamepad.Advanced.Blob
    | RemappingTool Evergreen.V1.Gamepad.Advanced.Model


type alias FrontendModel =
    { key : Browser.Navigation.Key
    , crate : Evergreen.V1.Crate.Model
    , gamepadState : GamepadState
    , userMappings : Evergreen.V1.Gamepad.Advanced.UserMappings
    }


type alias BackendModel =
    { message : String
    }


type FrontendMsg
    = UrlClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | CrateMsg Evergreen.V1.Crate.Msg
    | OnAnimationFrame Evergreen.V1.Gamepad.Advanced.Blob
    | OnRemappingToolMsg Evergreen.V1.Gamepad.Advanced.Msg
    | OnToggleRemap
    | NoOpFrontendMsg


type ToBackend
    = NoOpToBackend


type BackendMsg
    = NoOpBackendMsg


type ToFrontend
    = NoOpToFrontend
