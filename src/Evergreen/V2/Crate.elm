module Evergreen.V2.Crate exposing (..)

import WebGL.Texture


type alias Model =
    { texture : Maybe WebGL.Texture.Texture
    , theta : Float
    }


type Msg
    = TextureLoaded (Result WebGL.Texture.Error WebGL.Texture.Texture)
    | Animate Float
