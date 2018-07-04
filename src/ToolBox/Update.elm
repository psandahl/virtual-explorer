module ToolBox.Update exposing (init, openToolBox, closeToolBox)

{-| Module implementing the model manipulating functions for the ToolBox.
-}

import ToolBox.Model exposing (Model, State(..))


{-| Initialize the ToolBox.
-}
init : Model
init =
    { state = Closed }


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
