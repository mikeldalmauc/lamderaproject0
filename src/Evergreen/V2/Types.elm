module Evergreen.V2.Types exposing (..)

import Browser
import Browser.Navigation
import Evergreen.V2.Crate
import Evergreen.V2.Gamepad.Advanced
import Url


type GamepadState
    = Initializing
    | DisplayingGamepads Evergreen.V2.Gamepad.Advanced.Blob
    | RemappingTool Evergreen.V2.Gamepad.Advanced.Model


type alias FrontendModel =
    { key : Browser.Navigation.Key
    , crate : Evergreen.V2.Crate.Model
    , gamepadState : GamepadState
    , userMappings : Evergreen.V2.Gamepad.Advanced.UserMappings
    }


type alias BackendModel =
    { message : String
    }


type FrontendMsg
    = UrlClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | CrateMsg Evergreen.V2.Crate.Msg
    | OnAnimationFrame Evergreen.V2.Gamepad.Advanced.Blob
    | OnRemappingToolMsg Evergreen.V2.Gamepad.Advanced.Msg
    | OnToggleRemap
    | NoOpFrontendMsg


type ToBackend
    = NoOpToBackend


type BackendMsg
    = NoOpBackendMsg


type ToFrontend
    = NoOpToFrontend
