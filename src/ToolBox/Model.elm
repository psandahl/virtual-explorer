module ToolBox.Model
    exposing
        ( ChangeFunction
        , Checkbox(..)
        , Model
        , SliderChange(..)
        , State(..)
        )

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


type alias ChangeFunction =
    Model -> Float -> Model


type SliderChange
    = Change ChangeFunction


{-| Checkbox id.
-}
type Checkbox
    = UseFog


{-| The model.
-}
type alias Model =
    { state : State
    , octave0 : Vec3
    , octave1 : Vec3
    , octave2 : Vec3
    , color0 : Vec3
    , color1 : Vec3
    , color2 : Vec3
    , color3 : Vec3
    , sky0 : Vec3
    , sky1 : Vec3
    , useFog : Bool
    , fog : Vec3
    , fogPower : Float
    , ambientLightColor : Vec3
    , ambientLightStrength : Float
    , sunLightColor : Vec3
    , sunLightDirection : Vec3
    }
