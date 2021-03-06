module Graphics.Internal.Frustum
    exposing
        ( Frustum
        , fromCamera
        , fromVectors
        , containPoint
        )

{-| Implementation of light weight frustum for testing of points.
-}

import Camera.Model as Camera
import Settings
import Math.Vector3 as Vec3 exposing (Vec3)


{-| Frustum record.
-}
type alias Frustum =
    { cameraPosition : Vec3
    , aspectRatio : Float
    , tangFov : Float
    , x : Vec3
    , y : Vec3
    , z : Vec3
    }


{-| Create a frustum from a camera.
-}
fromCamera : Float -> Camera.Model -> Frustum
fromCamera aspectRatio camera =
    let
        lookAt =
            Vec3.add camera.position camera.viewDirection
    in
        fromVectors aspectRatio camera.position lookAt camera.upDirection


{-| Create a frustum from vectors.
-}
fromVectors : Float -> Vec3 -> Vec3 -> Vec3 -> Frustum
fromVectors aspectRatio cameraPosition cameraLookAt up =
    let
        z =
            Vec3.normalize <| Vec3.sub cameraPosition cameraLookAt

        x =
            Vec3.normalize <| Vec3.cross up z

        y =
            Vec3.normalize <| Vec3.cross z x
    in
        { cameraPosition = cameraPosition
        , aspectRatio = aspectRatio
        , tangFov =
            0.5 * (tan <| degrees Settings.fov)
        , x = x
        , y = y
        , z = z
        }


{-| Test if the point is inside the frustum.
-}
containPoint : Vec3 -> Frustum -> Bool
containPoint point frustum =
    let
        vec =
            Vec3.sub point frustum.cameraPosition

        pointZ =
            Vec3.dot vec <| Vec3.negate frustum.z
    in
        if (pointZ < Settings.nearPlane) || (pointZ > Settings.farPlane) then
            False
        else
            let
                pointY =
                    Vec3.dot vec frustum.y

                maxY =
                    frustum.tangFov * pointZ

                pointX =
                    Vec3.dot vec frustum.x

                maxX =
                    maxY * frustum.aspectRatio
            in
                if (pointY < -maxY) || (pointY > maxY) then
                    False
                else if (pointX < -maxX) || (pointX > maxX) then
                    False
                else
                    True
