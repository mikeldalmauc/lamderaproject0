module Types exposing (..)

import Browser exposing (UrlRequest)
import Browser.Navigation exposing (Key)
import Url exposing (Url)
import Crate


type alias FrontendModel =
    { key : Key
    , message : String
    , question : Question
    , crate : Crate.Model
    }


type alias BackendModel =
    { message : String
    }

type alias Question = 
    { question : String
    , options : List String
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