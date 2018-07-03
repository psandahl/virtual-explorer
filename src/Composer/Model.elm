module Composer.Model exposing (Model, Msg(..))

{-| Module implementing the composed model for complete application.
-}

import Compass.Model as Compass
import Graphics.Model as Graphics
import Window exposing (Size)


{-| Model record.
-}
type alias Model =
    { graphics : Graphics.Model
    , compass : Compass.Model
    , ctrlKeyDown : Bool
    }


{-| The message type.
-}
type Msg
    = SetViewport Size
    | CtrlKeyDown
    | CtrlKeyUp
    | Nop
