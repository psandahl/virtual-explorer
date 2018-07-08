module Graphics.Internal.Frustum exposing (Frustum, fromVectors)

{-| Implementation of light weight frustum for testing of points.
-}

import Camera.Model as Camera
import Graphics.Internal.Settings as Settings
import Math.Vector3 as Vec3 exposing (Vec3)
import Debug


type alias Frustum =
    { cameraPosition : Vec3
    , frustumX : Vec3
    , frustumY : Vec3
    , frustumZ : Vec3
    , nearTopLeft : Vec3
    , nearTopRight : Vec3
    , nearBottomLeft : Vec3
    , nearBottomRight : Vec3
    , farTopLeft : Vec3
    , farTopRight : Vec3
    , farBottomLeft : Vec3
    , farBottomRight : Vec3
    }


fromVectors : Float -> Vec3 -> Vec3 -> Vec3 -> Frustum
fromVectors aspectRatio cameraPosition cameraLookAt up =
    let
        frustumZ =
            Vec3.normalize <| Vec3.sub cameraPosition cameraLookAt

        frustumX =
            Vec3.normalize <| Vec3.cross up frustumZ

        frustumY =
            Vec3.normalize <| Vec3.cross frustumZ frustumX

        fovTang =
            tan <| degrees Settings.fov

        nearHeight =
            fovTang * Settings.near

        nearWidth =
            nearHeight * aspectRatio

        farHeight =
            fovTang * Settings.far

        farWidth =
            farHeight * aspectRatio

        nearCenter =
            Debug.log "nearCenter" <|
                Vec3.sub cameraPosition <|
                    Vec3.scale Settings.near frustumZ

        farCenter =
            Debug.log "farCenter" <|
                Vec3.sub cameraPosition <|
                    Vec3.scale Settings.far frustumZ

        scaledNearHeight =
            Vec3.scale (nearHeight / 2) frustumY

        scaledNearWidth =
            Vec3.scale (nearWidth / 2) frustumX

        scaledFarHeight =
            Vec3.scale (farHeight / 2) frustumY

        scaledFarWidth =
            Vec3.scale (farWidth / 2) frustumX
    in
        { cameraPosition = cameraPosition
        , frustumX = frustumX
        , frustumY = frustumY
        , frustumZ = frustumZ
        , nearTopLeft = Vec3.add nearCenter <| Vec3.add scaledNearHeight scaledNearWidth
        , nearTopRight = Vec3.add nearCenter <| Vec3.sub scaledNearHeight scaledNearWidth
        , nearBottomLeft = Vec3.sub nearCenter <| Vec3.sub scaledNearHeight scaledNearWidth
        , nearBottomRight = Vec3.sub nearCenter <| Vec3.add scaledNearHeight scaledNearWidth
        , farTopLeft = Vec3.add farCenter <| Vec3.add scaledFarHeight scaledFarWidth
        , farTopRight = Vec3.add farCenter <| Vec3.sub scaledFarHeight scaledFarWidth
        , farBottomLeft = Vec3.sub farCenter <| Vec3.sub scaledFarHeight scaledFarWidth
        , farBottomRight = Vec3.sub farCenter <| Vec3.add scaledFarHeight scaledFarWidth
        }
