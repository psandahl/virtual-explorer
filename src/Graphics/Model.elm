module Graphics.Model exposing (Model)

{-| Module implementing the model for the graphics view.
-}

import Math.Matrix4 exposing (Mat4)
import Window exposing (Size)


{-| Graphics state model. The model owns the projection matrix, which is
adapted to the current viewport size.
-}
type alias Model =
    { viewport : Size
    , projectionMatrix : Mat4
    }
