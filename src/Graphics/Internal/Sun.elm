module Graphics.Internal.Sun exposing (sunWithFlares)

{-| A simple system to render sun with a simple lens flare effect.
-}

import Debug
import Html exposing (Html)
import Html.Attributes as Attr
import Math.Matrix4 as Mat4 exposing (Mat4)
import Math.Vector3 as Vec3 exposing (Vec3)
import Window exposing (Size)


{-| Projection matrix, view matrix and the sun's direction.
-}
sunWithFlares : Size -> Mat4 -> Mat4 -> Vec3 -> List (Html msg)
sunWithFlares viewport projectionMatrix viewMatrix sunLightDirection =
    let
        sunPosition =
            Vec3.scale 1000 sunLightDirection

        matrices =
            Mat4.mul projectionMatrix viewMatrix

        ndc =
            Mat4.transform matrices sunPosition

        screenCoords =
            ( (Vec3.getX ndc * 0.5 + 0.5) * toFloat viewport.width
            , toFloat viewport.height - (Vec3.getY ndc * 0.5 + 0.5) * toFloat viewport.height
            )
    in
    if isVisible viewport screenCoords then
        makeSunWithFlares viewport screenCoords
    else
        []


isVisible : Size -> ( Float, Float ) -> Bool
isVisible viewport ( screenX, screenY ) =
    screenX >= 0.0 && screenX < toFloat viewport.width && screenY >= 0 && screenY < toFloat viewport.height


makeSunWithFlares : Size -> ( Float, Float ) -> List (Html msg)
makeSunWithFlares viewport ( screenX, screenY ) =
    [ Html.div
        [ Attr.style
            [ ( "background-image", "url('./images/sun.png')" )
            , ( "background-size", "cover" )
            , ( "position", "absolute" )
            , ( "left", toString (screenX - 50) ++ "px" )
            , ( "top", toString (screenY - 50) ++ "px" )
            , ( "width", "100px" )
            , ( "height", "100px" )
            , ( "z-index", "1" )
            ]
        ]
        []
    ]
