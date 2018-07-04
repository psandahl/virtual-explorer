module Camera.Update
    exposing
        ( init
        , setViewport
        , mouseMovePosition
        , mouseRotateCamera
        )

{-| Module implementing model manipulating functions for the camera.
-}

import Camera.Model exposing (Model)
import Mouse exposing (Position)
import Window exposing (Size)


{-| Initialize the camera.
-}
init : Size -> Model
init viewport =
    { viewport = viewport
    , heading = 0
    }


{-| Set a new viewport.
-}
setViewport : Size -> Model -> Model
setViewport viewport model =
    { model | viewport = viewport }


{-| Move camera position from a change in mouse position.
-}
mouseMovePosition : Position -> Position -> Model -> Model
mouseMovePosition from to model =
    model


{-| Rotate camera from a change in mouse position.
-}
mouseRotateCamera : Position -> Position -> Model -> Model
mouseRotateCamera from to model =
    let
        deltaX =
            to.x - from.x

        normalizedChange =
            if model.viewport.width < 360 then
                toFloat deltaX
            else
                (toFloat deltaX) / (toFloat model.viewport.width) * 360

        heading =
            (model.heading + round normalizedChange)
                % 360
    in
        { model | heading = heading }
