port module PkgPorts exposing (..)

import Gamepad.Advanced exposing (Blob)
import Json.Encode

ports =
    { 
    -- Gamepad 
        saveToLocalStorage = saveToLocalStorage
    ,   onBlob = onBlob

    -- Audio
    ,   toWebAudio = toWebAudio
    }


-- Gamepad Ports
port onBlob : (Blob -> msg) -> Sub msg

port saveToLocalStorage : String -> Cmd aOrigin

-- Audio
port toWebAudio : Json.Encode.Value -> Cmd msg