module ToolBox.Update
    exposing
        ( init
        , openToolBox
        , closeToolBox
        , setSliderValue
        )

{-| Module implementing the model manipulating functions for the ToolBox.
-}

import ToolBox.Model exposing (Model, State(..), Slider(..))
import Math.Vector3 as Vec3


{-| Initialize the ToolBox.
-}
init : Model
init =
    { state = Closed
    , octave0WaveLength = 512
    , octave0Altitude = 0
    , color0 = Vec3.vec3 0.4 0.4 0.4
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
setSliderValue : Slider -> Int -> Model -> Model
setSliderValue slider value model =
    case slider of
        Octave0WaveLength ->
            { model | octave0WaveLength = value }

        Octave0Altitude ->
            { model | octave0Altitude = value }
