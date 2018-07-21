module Graphics.Internal.Sun exposing (sunWithFlares)

{-| A simple system to render sun with a simple lens flare effect.
-}

import Html.Attributes as Attr
import Html exposing (Html)
import Math.Matrix4 exposing (Mat4)
import Math.Vector3 exposing (Vec3)


{-| Projection matrix, view matrix and the sun's direction.
-}
sunWithFlares : Mat4 -> Mat4 -> Vec3 -> List (Html msg)
sunWithFlares projectionMatrix viewMatrix sunLightDirection =
    [ Html.div
        [ Attr.style
            [ ( "background-image", "url('./images/sun.png')" )
            , ( "background-size", "cover" )
            , ( "position", "absolute" )
            , ( "left", "150px" )
            , ( "top", "150px" )
            , ( "width", "100px" )
            , ( "height", "100px" )
            , ( "z-index", "1" )
            ]
        , Attr.class "sun"
        ]
        []
    ]
