module ToolBox.Model exposing (Model, State(..), Slider(..))

{-| Module implementing the model for the tool box. The tool box have a
collection of values used for the rendering. The values are adjustable in
the tool box's view.
-}

import Math.Vector3 exposing (Vec3)


{-| The state for the ToolBox; it's either closed or open.
-}
type State
    = Closed
    | Open


{-| Slider id.
-}
type Slider
    = Octave0WaveLength
    | Octave0Altitude


{-| The model.
-}
type alias Model =
    { state : State
    , octave0WaveLength : Int
    , octave0Altitude : Int
    , color0 : Vec3
    , ambientLightColor : Vec3
    , ambientLightStrength : Float
    , sunLightColor : Vec3
    , sunLightDirection : Vec3
    }
