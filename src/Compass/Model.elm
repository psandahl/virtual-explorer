module Compass.Model exposing (Model)

{-| Module implementing the model for the compass view.
-}

import Window exposing (Size)


{-| The compass model.
-}
type alias Model =
    { viewport : Size }
