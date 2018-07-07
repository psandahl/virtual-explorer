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
import Math.Vector3 as Vec3 exposing (Vec3)
import Math.Matrix4 as Mat4 exposing (Mat4)
import Mouse exposing (Position)
import Window exposing (Size)


{-| Initialize the camera.
-}
init : Size -> Model
init viewport =
    let
        defaultViewDirection =
            makeViewDirection defaultHeading defaultPitch
    in
        { viewport = viewport
        , heading = defaultHeading
        , pitch = defaultPitch
        , position = defaultPosition
        , viewDirection = defaultViewDirection
        , viewMatrix = makeViewMatrix defaultPosition defaultViewDirection
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

        viewDirection =
            makeViewDirection heading model.pitch

        viewMatrix =
            makeViewMatrix model.position viewDirection
    in
        { model
            | heading = heading
            , viewDirection = viewDirection
            , viewMatrix = viewMatrix
        }


defaultHeading : Int
defaultHeading =
    0


defaultPitch : Int
defaultPitch =
    45


defaultPosition : Vec3
defaultPosition =
    Vec3.vec3 0 100 0


makeViewMatrix : Vec3 -> Vec3 -> Mat4
makeViewMatrix position viewDirection =
    Mat4.makeLookAt position (Vec3.add position viewDirection) <| Vec3.vec3 0 1 0


makeViewDirection : Int -> Int -> Vec3
makeViewDirection heading pitch =
    let
        ahead =
            Vec3.vec3 0 0 1

        pitchMatrix =
            Mat4.makeRotate (degrees <| toFloat pitch) <| Vec3.vec3 1 0 0

        headingMatrix =
            Mat4.makeRotate (degrees <| toFloat heading) <| Vec3.vec3 0 1 0

        rotateMatrix =
            Mat4.mul headingMatrix pitchMatrix
    in
        Vec3.normalize <| Mat4.transform rotateMatrix ahead
