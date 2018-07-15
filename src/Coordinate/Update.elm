module Coordinate.Update exposing (init, setViewport)

{-| Model manipulating functions for the coordinate view.
-}

import Coordinate.Model exposing (Model)
import Window exposing (Size)


{-| Initialize the coordinate widget.
-}
init : Size -> Model
init viewport =
    { viewport = viewport }


{-| Set a new viewport.
-}
setViewport : Size -> Model -> Model
setViewport viewport model =
    { model | viewport = viewport }
