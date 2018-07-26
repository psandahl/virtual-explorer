module Composer.Model exposing (Model, Msg(..))

{-| Module implementing the composed model for complete application.
-}

import Camera.Model as Camera
import Compass.Model as Compass
import Coordinate.Model as Coordinate
import Graphics.Model as Graphics
import Mouse exposing (Position)
import ToolBox.Model as ToolBox exposing (Checkbox, Slider, SliderChange)
import Window exposing (Size)


{-| Model record.
-}
type alias Model =
    { graphics : Graphics.Model
    , coordinate : Coordinate.Model
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
    | ToolBoxSliderChange Slider Float
    | ToolBoxSliderChange2 SliderChange Float
    | ToolBoxCheckboxToggle Checkbox
    | Nop
