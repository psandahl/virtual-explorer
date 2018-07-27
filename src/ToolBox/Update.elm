module ToolBox.Update
    exposing
        ( closeToolBox
        , init
        , openToolBox
        , setSliderValue
        , toggleCheckbox
        )

{-| Module implementing the model manipulating functions for the ToolBox.
-}

import Math.Vector3 as Vec3
import Settings
import ToolBox.Model exposing (Checkbox(..), Model, SliderChange(..), State(..))


{-| Initialize the ToolBox.
-}
init : Model
init =
    { state = Closed
    , octave0 = Vec3.vec3 Settings.octave0MaxWaveLength Settings.octave0MaxWaveLength 0
    , octave1 = Vec3.vec3 Settings.octave1MaxWaveLength Settings.octave1MaxWaveLength 0
    , octave2 = Vec3.vec3 Settings.octave2MaxWaveLength Settings.octave2MaxWaveLength 0
    , color0 = Vec3.vec3 (115 / 255) (69 / 255) (35 / 255)
    , color1 = Vec3.vec3 (57 / 255) (118 / 255) (40 / 255)
    , color2 = Vec3.vec3 (45 / 255) (58 / 255) (61 / 255)
    , color3 = Vec3.vec3 1 1 1
    , sky0 = Vec3.vec3 (246 / 255) (176 / 255) (133 / 255)
    , sky1 = Vec3.vec3 (70 / 255) (106 / 255) (200 / 255)
    , useFog = False
    , fog = Vec3.vec3 0.5 0.5 0.5
    , fogPower = 1
    , ambientLightColor = Vec3.vec3 1 1 1
    , ambientLightStrength = 0.2
    , sunLightColor = Vec3.vec3 1 1 1
    , sunLightDirection = Vec3.normalize <| Vec3.vec3 -1.5 1 0 -- Sun from the east (remember: north is positive z)
    }


{-| Open the ToolBox.
-}
openToolBox : Model -> Model
openToolBox model =
    { model | state = Open }


{-| Close the ToolBox.
-}
closeToolBox : Model -> Model
closeToolBox model =
    { model | state = Closed }


{-| Set the value for the given slider.
-}
setSliderValue : SliderChange -> Float -> Model -> Model
setSliderValue change value model =
    case change of
        Change g ->
            g model value


{-| Toggle the value for the given checkbox.
-}
toggleCheckbox : Checkbox -> Model -> Model
toggleCheckbox checkbox model =
    case checkbox of
        UseFog ->
            { model | useFog = not model.useFog }
