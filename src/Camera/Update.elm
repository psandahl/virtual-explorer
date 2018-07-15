module Camera.Update
    exposing
        ( init
        , mouseMoveWorldOffset
        , mouseRotateCamera
        , setViewport
        )

{-| Module implementing model manipulating functions for the camera. All angles
are degrees.
-}

import Camera.Model exposing (Model)
import Math.Matrix4 as Mat4 exposing (Mat4)
import Math.Vector2 as Vec2 exposing (Vec2)
import Math.Vector3 as Vec3 exposing (Vec3)
import Mouse exposing (Position)
import Settings
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
    , worldOffset = defaultWorldOffset
    , heading = defaultHeading
    , pitch = defaultPitch
    , position = defaultPosition
    , viewDirection = defaultViewDirection
    , upDirection = defaultUpDirection
    , viewMatrix = makeViewMatrix defaultPosition defaultViewDirection defaultUpDirection
    }


{-| Set a new viewport.
-}
setViewport : Size -> Model -> Model
setViewport viewport model =
    { model | viewport = viewport }


{-| Move world offset from a mouse move. Adapt to heading angle.
-}
mouseMoveWorldOffset : Position -> Position -> Model -> Model
mouseMoveWorldOffset from to model =
    let
        fromVec =
            Vec3.vec3 (toFloat from.x) (toFloat from.y) 0

        toVec =
            Vec3.vec3 (toFloat to.x) (toFloat to.y) 0

        rotZ =
            Mat4.makeRotate (degrees <| toFloat -model.heading) <| Vec3.vec3 0 0 1

        move =
            Mat4.transform rotZ <| Vec3.sub toVec fromVec

        current =
            Vec3.vec3 (Vec2.getX model.worldOffset) (Vec2.getY model.worldOffset) 0

        new =
            Vec3.add current move
    in
    { model | worldOffset = Vec2.vec2 (Vec3.getX new) (Vec3.getY new) }


{-| Rotate camera from a change in mouse position.
-}
mouseRotateCamera : Position -> Position -> Model -> Model
mouseRotateCamera from to model =
    let
        deltaX =
            to.x - from.x

        normalizedXChange =
            if model.viewport.width < 360 then
                toFloat deltaX
            else
                toFloat deltaX / toFloat model.viewport.width * 360

        heading =
            (model.heading + round normalizedXChange)
                % 360

        deltaY =
            from.y - to.y

        normalizedYChange =
            if model.viewport.height < 360 then
                toFloat deltaY
            else
                toFloat deltaY / toFloat model.viewport.height * 120

        pitch =
            clamp -60 60 <| model.pitch + round normalizedYChange

        viewDirection =
            makeViewDirection heading pitch

        viewMatrix =
            makeViewMatrix model.position viewDirection model.upDirection
    in
    { model
        | heading = heading
        , pitch = pitch
        , viewDirection = viewDirection
        , viewMatrix = viewMatrix
    }


{-| The default world offset.
-}
defaultWorldOffset : Vec2
defaultWorldOffset =
    Vec2.vec2 0 0


{-| Default heading angle. North is in positive z direction.
-}
defaultHeading : Int
defaultHeading =
    0


{-| Default pitch angle.
-}
defaultPitch : Int
defaultPitch =
    10


{-| Default position.
-}
defaultPosition : Vec3
defaultPosition =
    Vec3.vec3 0 (toFloat Settings.maxCameraAltitude) 0


{-| Default up direction.
-}
defaultUpDirection : Vec3
defaultUpDirection =
    Vec3.vec3 0 1 0


{-| Make a view matrix.
-}
makeViewMatrix : Vec3 -> Vec3 -> Vec3 -> Mat4
makeViewMatrix position viewDirection upDirection =
    Mat4.makeLookAt position (Vec3.add position viewDirection) upDirection


{-| Make a view direction vector from heading and pitch.
-}
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
