module Composer.Model exposing (Model, Msg(..))

{-| Module implementing the composed model for complete application.
-}

import Camera.Model as Camera
import Compass.Model as Compass
import Graphics.Model as Graphics
import ToolBox.Model as ToolBox
import Mouse exposing (Position)
import Window exposing (Size)


{-| Model record.
-}
type alias Model =
    { graphics : Graphics.Model
    , compass : Compass.Model
    , camera : Camera.Model
    , toolBox : ToolBox.Model
    , ctrlKeyDown : Bool
    , trackedMousePosition : Maybe Position
    }


{-| The message type.
-}
type Msg
    = SetViewport Size
    | CtrlKeyDown
    | CtrlKeyUp
    | GraphicsViewMouseDown Position
    | GraphicsViewMouseMoved Position
    | GraphicsViewMouseReleased Position
    | OpenToolBox
    | CloseToolBox
    | Nop
