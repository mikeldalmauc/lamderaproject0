port module PkgPorts exposing (..)

-- This file is an example of what `elm-pkg-js` would generate for the user
import Gamepad.Advanced exposing (Blob)

ports =
    { 
        saveToLocalStorage = saveToLocalStorage
    ,   onBlob = onBlob
    }

port onBlob : (Blob -> msg) -> Sub msg


port saveToLocalStorage : String -> Cmd aOrigin