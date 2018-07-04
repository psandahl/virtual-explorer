module ToolBox.Model exposing (Model, State(..))

{-| Module implementing the model for the tool box.
-}


{-| The state for the ToolBox; it's either closed or open.
-}
type State
    = Closed
    | Open


{-| The model.
-}
type alias Model =
    { state : State
    }
