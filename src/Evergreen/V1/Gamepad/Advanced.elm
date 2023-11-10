module Evergreen.V1.Gamepad.Advanced exposing (..)

import Dict
import Evergreen.V1.Gamepad
import Evergreen.V1.Gamepad.Private


type alias Blob =
    Evergreen.V1.Gamepad.Private.Blob


type WaitingFor
    = AllButtonsUp
    | SomeButtonDown


type alias Remapping =
    { id : String
    , index : Int
    , pairs : List ( Evergreen.V1.Gamepad.Private.Origin, Evergreen.V1.Gamepad.Digital )
    , skipped : List Evergreen.V1.Gamepad.Digital
    , waitingFor : WaitingFor
    }


type alias WrappedModel =
    { blob : Blob
    , maybeRemapping : Maybe Remapping
    , controls : List ( String, Evergreen.V1.Gamepad.Digital )
    }


type Model
    = Model WrappedModel


type UserMappings
    = UserMappings
        { byIndexAndId : Dict.Dict ( Int, String ) Evergreen.V1.Gamepad.Private.Mapping
        , byId : Dict.Dict String Evergreen.V1.Gamepad.Private.Mapping
        }


type Msg
    = Noop
    | OnGamepad Blob
    | OnStartRemapping String Int
    | OnSkip Evergreen.V1.Gamepad.Digital
    | OnCancel
