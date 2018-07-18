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
import ToolBox.Model exposing (Checkbox(..), Model, Slider(..), State(..))


{-| Initialize the ToolBox.
-}
init : Model
init =
    { state = Closed
    , octave0HorizontalWaveLength = Settings.octave0MaxWaveLength
    , octave0VerticalWaveLength = Settings.octave0MaxWaveLength
    , octave0Altitude = 0
    , octave1HorizontalWaveLength = Settings.octave1MaxWaveLength
    , octave1VerticalWaveLength = Settings.octave1MaxWaveLength
    , octave1Altitude = 0
    , octave2HorizontalWaveLength = Settings.octave2MaxWaveLength
    , octave2VerticalWaveLength = Settings.octave2MaxWaveLength
    , octave2Altitude = 0
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
    , sunLightDirection = Vec3.normalize <| Vec3.vec3 -1 1 0 -- Sun from the east (remember: north is positive z)
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
setSliderValue : Slider -> Float -> Model -> Model
setSliderValue slider value model =
    case slider of
        Octave0HorizontalWaveLength ->
            { model | octave0HorizontalWaveLength = value }

        Octave0VerticalWaveLength ->
            { model | octave0VerticalWaveLength = value }

        Octave0Altitude ->
            { model | octave0Altitude = value }

        Octave1HorizontalWaveLength ->
            { model | octave1HorizontalWaveLength = value }

        Octave1VerticalWaveLength ->
            { model | octave1VerticalWaveLength = value }

        Octave1Altitude ->
            { model | octave1Altitude = value }

        Octave2HorizontalWaveLength ->
            { model | octave2HorizontalWaveLength = value }

        Octave2VerticalWaveLength ->
            { model | octave2VerticalWaveLength = value }

        Octave2Altitude ->
            { model | octave2Altitude = value }

        Color0R ->
            { model | color0 = Vec3.setX (value / 255.0) model.color0 }

        Color0G ->
            { model | color0 = Vec3.setY (value / 255.0) model.color0 }

        Color0B ->
            { model | color0 = Vec3.setZ (value / 255.0) model.color0 }

        Color1R ->
            { model | color1 = Vec3.setX (value / 255.0) model.color1 }

        Color1G ->
            { model | color1 = Vec3.setY (value / 255.0) model.color1 }

        Color1B ->
            { model | color1 = Vec3.setZ (value / 255.0) model.color1 }

        Color2R ->
            { model | color2 = Vec3.setX (value / 255.0) model.color2 }

        Color2G ->
            { model | color2 = Vec3.setY (value / 255.0) model.color2 }

        Color2B ->
            { model | color2 = Vec3.setZ (value / 255.0) model.color2 }

        Color3R ->
            { model | color3 = Vec3.setX (value / 255.0) model.color3 }

        Color3G ->
            { model | color3 = Vec3.setY (value / 255.0) model.color3 }

        Color3B ->
            { model | color3 = Vec3.setZ (value / 255.0) model.color3 }

        FogPower ->
            { model | fogPower = value }


{-| Toggle the value for the given checkbox.
-}
toggleCheckbox : Checkbox -> Model -> Model
toggleCheckbox checkbox model =
    case checkbox of
        UseFog ->
            { model | useFog = not model.useFog }
