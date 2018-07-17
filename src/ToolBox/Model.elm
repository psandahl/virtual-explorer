module ToolBox.Model exposing (Model, Slider(..), State(..))

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
    = Octave0HorizontalWaveLength
    | Octave0VerticalWaveLength
    | Octave0Altitude
    | Octave1HorizontalWaveLength
    | Octave1VerticalWaveLength
    | Octave1Altitude
    | Octave2HorizontalWaveLength
    | Octave2VerticalWaveLength
    | Octave2Altitude
    | Color0R
    | Color0G
    | Color0B
    | Color1R
    | Color1G
    | Color1B
    | Color2R
    | Color2G
    | Color2B
    | Color3R
    | Color3G
    | Color3B


{-| The model.
-}
type alias Model =
    { state : State
    , octave0HorizontalWaveLength : Int
    , octave0VerticalWaveLength : Int
    , octave0Altitude : Int
    , octave1HorizontalWaveLength : Int
    , octave1VerticalWaveLength : Int
    , octave1Altitude : Int
    , octave2HorizontalWaveLength : Int
    , octave2VerticalWaveLength : Int
    , octave2Altitude : Int
    , color0 : Vec3
    , color1 : Vec3
    , color2 : Vec3
    , color3 : Vec3
    , sky0 : Vec3
    , sky1 : Vec3
    , fog : Vec3
    , fogDistance : Float
    , ambientLightColor : Vec3
    , ambientLightStrength : Float
    , sunLightColor : Vec3
    , sunLightDirection : Vec3
    }
