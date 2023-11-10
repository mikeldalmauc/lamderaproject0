module Evergreen.V2.Gamepad.Private exposing (..)

import Array
import Dict


type alias GamepadFrame =
    { axes : Array.Array Float
    , buttons : Array.Array ( Bool, Float )
    , id : String
    , index : Int
    , mapping : String
    }


type alias BlobFrame =
    { gamepads : List GamepadFrame
    , timestamp : Float
    }


type alias Environment =
    { userMappings : String
    , languages : List String
    }


type alias Blob =
    ( BlobFrame, BlobFrame, Environment )


type OriginType
    = Axis
    | Button


type Origin
    = Origin Bool OriginType Int


type alias Mapping =
    Dict.Dict String Origin
