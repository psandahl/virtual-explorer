module ToolBox.Model exposing (Model, State(..), Slider(..))

{-| Module implementing the model for the tool box.
-}


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
    }
