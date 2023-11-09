module Evergreen.V1.Types exposing (..)

import Browser
import Browser.Navigation
import Evergreen.V1.Crate
import Url


type alias FrontendModel =
    { key : Browser.Navigation.Key
    , crate : Evergreen.V1.Crate.Model
    }


type alias BackendModel =
    { message : String
    }


type FrontendMsg
    = UrlClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | CrateMsg Evergreen.V1.Crate.Msg
    | NoOpFrontendMsg


type ToBackend
    = NoOpToBackend


type BackendMsg
    = NoOpBackendMsg


type ToFrontend
    = NoOpToFrontend
