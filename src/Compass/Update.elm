module Compass.Update exposing (init, setAngle)

{-| Model manipulating functions for the compass view.
-}

import Compass.Model exposing (Model)


{-| Initialize the compass.
-}
init : Model
init =
    { angle = 0 }


{-| Set the angle for the compass.
-}
setAngle : Float -> Model -> Model
setAngle angle model =
    { model | angle = angle }
