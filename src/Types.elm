module Types exposing (..)

import Browser exposing (UrlRequest)
import Browser.Navigation exposing (Key)
import Url exposing (Url)
import Crate


type alias FrontendModel =
    { key : Key
    , crate : Crate.Model
    }


type alias BackendModel =
    { message : String
    }

type FrontendMsg
    = UrlClicked UrlRequest
    | UrlChanged Url
    | CrateMsg Crate.Msg
    | NoOpFrontendMsg


type ToBackend
    = NoOpToBackend


type BackendMsg
    = NoOpBackendMsg


type ToFrontend
    = NoOpToFrontend