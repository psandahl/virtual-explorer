module Camera.Update exposing (init, mouseMovePosition, mouseRotateCamera)

{-| Module implementing model manipulating functions for the camera.
-}

import Camera.Model exposing (Model)
import Mouse exposing (Position)


{-| Initialize the camera.
-}
init : Model
init =
    {}


{-| Move camera position from a change in mouse position.
-}
mouseMovePosition : Position -> Position -> Model -> Model
mouseMovePosition from to model =
    model


{-| Rotate camera from a change in mouse position.
-}
mouseRotateCamera : Position -> Position -> Model -> Model
mouseRotateCamera from to model =
    model
