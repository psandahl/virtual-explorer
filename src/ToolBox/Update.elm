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


{-| Initialize the ToolBox.
-}
init : Model
init =
    { state = Closed
    , octave0WaveLength = 50
    , octave0Altitude = 50
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
