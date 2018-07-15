module Coordinate.Model exposing (Model)

{-| Module implementing the model for the coordinate view.
-}

import Window exposing (Size)


{-| The coordinate model.
-}
type alias Model =
    { viewport : Size
    }
