module Evergreen.V2.Gamepad.Advanced exposing (..)

import Dict
import Evergreen.V2.Gamepad
import Evergreen.V2.Gamepad.Private


type alias Blob =
    Evergreen.V2.Gamepad.Private.Blob


type WaitingFor
    = AllButtonsUp
    | SomeButtonDown


type alias Remapping =
    { id : String
    , index : Int
    , pairs : List ( Evergreen.V2.Gamepad.Private.Origin, Evergreen.V2.Gamepad.Digital )
    , skipped : List Evergreen.V2.Gamepad.Digital
    , waitingFor : WaitingFor
    }


type alias WrappedModel =
    { blob : Blob
    , maybeRemapping : Maybe Remapping
    , controls : List ( String, Evergreen.V2.Gamepad.Digital )
    }


type Model
    = Model WrappedModel


type UserMappings
    = UserMappings
        { byIndexAndId : Dict.Dict ( Int, String ) Evergreen.V2.Gamepad.Private.Mapping
        , byId : Dict.Dict String Evergreen.V2.Gamepad.Private.Mapping
        }


type Msg
    = Noop
    | OnGamepad Blob
    | OnStartRemapping String Int
    | OnSkip Evergreen.V2.Gamepad.Digital
    | OnCancel
