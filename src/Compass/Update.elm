module Compass.Update exposing (init, setViewport)

{-| Model manipulating functions for the compass view.
-}

import Compass.Model exposing (Model)
import Window exposing (Size)


{-| Initialize the compass.
-}
init : Size -> Model
init viewport =
    { viewport = viewport }


{-| Set a new viewport.
-}
setViewport : Size -> Model -> Model
setViewport viewport model =
    { model | viewport = viewport }
