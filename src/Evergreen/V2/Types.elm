module Evergreen.V2.Types exposing (..)

import Browser
import Browser.Navigation
import Evergreen.V2.Crate
import Url


type alias Question =
    { question : String
    , options : List String
    }


type alias FrontendModel =
    { key : Browser.Navigation.Key
    , message : String
    , question : Question
    , crate : Evergreen.V2.Crate.Model
    }


type alias BackendModel =
    { message : String
    }


type FrontendMsg
    = UrlClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | CrateMsg Evergreen.V2.Crate.Msg
    | NoOpFrontendMsg


type ToBackend
    = NoOpToBackend


type BackendMsg
    = NoOpBackendMsg


type ToFrontend
    = NoOpToFrontend
