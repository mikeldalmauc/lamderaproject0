module Evergreen.Migrate.V2 exposing (..)

{-| This migration file was automatically generated by the lamdera compiler.

It includes:

  - A migration for each of the 6 Lamdera core types that has changed
  - A function named `migrate_ModuleName_TypeName` for each changed/custom type

Expect to see:

  - `Unimplementеd` values as placeholders wherever I was unable to figure out a clear migration path for you
  - `@NOTICE` comments for things you should know about, i.e. new custom type constructors that won't get any
    value mappings from the old type by default

You can edit this file however you wish! It won't be generated again.

See <https://dashboard.lamdera.app/docs/evergreen> for more info.

-}

import Evergreen.V1.Crate
import Evergreen.V1.Types
import Evergreen.V2.Crate
import Evergreen.V2.Types
import Lamdera.Migrations exposing (..)
import Types exposing (GamepadState(..))
import Gamepad.Advanced as Adv


frontendModel : Evergreen.V1.Types.FrontendModel -> ModelMigration Evergreen.V2.Types.FrontendModel Evergreen.V2.Types.FrontendMsg
frontendModel old =
    ModelMigrated ( migrate_Types_FrontendModel old, Cmd.none )


backendModel : Evergreen.V1.Types.BackendModel -> ModelMigration Evergreen.V2.Types.BackendModel Evergreen.V2.Types.BackendMsg
backendModel old =
    ModelUnchanged


frontendMsg : Evergreen.V1.Types.FrontendMsg -> MsgMigration Evergreen.V2.Types.FrontendMsg Evergreen.V2.Types.FrontendMsg
frontendMsg old =
    MsgMigrated ( migrate_Types_FrontendMsg old, Cmd.none )


toBackend : Evergreen.V1.Types.ToBackend -> MsgMigration Evergreen.V2.Types.ToBackend Evergreen.V2.Types.BackendMsg
toBackend old =
    MsgUnchanged


backendMsg : Evergreen.V1.Types.BackendMsg -> MsgMigration Evergreen.V2.Types.BackendMsg Evergreen.V2.Types.BackendMsg
backendMsg old =
    MsgUnchanged


toFrontend : Evergreen.V1.Types.ToFrontend -> MsgMigration Evergreen.V2.Types.ToFrontend Evergreen.V2.Types.FrontendMsg
toFrontend old =
    MsgUnchanged


migrate_Types_FrontendModel : Evergreen.V1.Types.FrontendModel -> Evergreen.V2.Types.FrontendModel
migrate_Types_FrontendModel old =
    { key = old.key
    , crate = old.crate |> migrate_Crate_Model
    , gamepadState = Initializing
    , userMappings = Adv.emptyUserMappings
    }


migrate_Crate_Model : Evergreen.V1.Crate.Model -> Evergreen.V2.Crate.Model
migrate_Crate_Model old =
    old


migrate_Crate_Msg : Evergreen.V1.Crate.Msg -> Evergreen.V2.Crate.Msg
migrate_Crate_Msg old =
    case old of
        Evergreen.V1.Crate.TextureLoaded p0 ->
            Evergreen.V2.Crate.TextureLoaded p0

        Evergreen.V1.Crate.Animate p0 ->
            Evergreen.V2.Crate.Animate p0


migrate_Types_FrontendMsg : Evergreen.V1.Types.FrontendMsg -> Evergreen.V2.Types.FrontendMsg
migrate_Types_FrontendMsg old =
    case old of
        Evergreen.V1.Types.UrlClicked p0 ->
            Evergreen.V2.Types.UrlClicked p0

        Evergreen.V1.Types.UrlChanged p0 ->
            Evergreen.V2.Types.UrlChanged p0

        Evergreen.V1.Types.CrateMsg p0 ->
            Evergreen.V2.Types.CrateMsg (p0 |> migrate_Crate_Msg)

        Evergreen.V1.Types.NoOpFrontendMsg ->
            Evergreen.V2.Types.NoOpFrontendMsg