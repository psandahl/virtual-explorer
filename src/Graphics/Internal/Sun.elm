module Graphics.Internal.Sun exposing (sunWithFlares)

{-| A simple system to render sun with a simple lens flare effect.
-}

import Debug
import Html exposing (Html)
import Html.Attributes as Attr
import Math.Matrix4 as Mat4 exposing (Mat4)
import Math.Vector2 as Vec2 exposing (Vec2)
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
    let
        sunPosition =
            Debug.log "sun: " <| Vec2.vec2 screenX screenY

        midPosition =
            Debug.log "mid: " <| midViewport viewport

        sunVector =
            Debug.log "sunVec: " <| Vec2.sub midPosition sunPosition

        endPosition =
            Debug.log "end: " <| Vec2.add midPosition sunVector

        distance =
            Debug.log "dist: " <| abs (Vec2.distance endPosition sunPosition)

        direction =
            Debug.log "direction: " <| Vec2.normalize <| Vec2.sub endPosition sunPosition
    in
    renderImage sunPosition direction ( "./images/sun.png", 0.0, 1.0, 100, 100 )
        :: List.map (renderImage sunPosition direction)
            [ ( "./images/tex1.png", 0.1 * distance, 0.15, 100, 100 )
            , ( "./images/tex2.png", 0.2 * distance, 0.15, 200, 200 )
            , ( "./images/tex3.png", 0.3 * distance, 0.15, 100, 100 )
            , ( "./images/tex4.png", 0.4 * distance, 0.15, 300, 300 )
            , ( "./images/tex5.png", 0.5 * distance, 0.15, 100, 100 )
            , ( "./images/tex6.png", 0.6 * distance, 0.15, 200, 200 )
            , ( "./images/tex7.png", 0.7 * distance, 0.15, 200, 200 )
            , ( "./images/tex8.png", 0.9 * distance, 0.15, 200, 200 )
            , ( "./images/tex9.png", distance, 0.15, 100, 100 )
            ]


renderImage : Vec2 -> Vec2 -> ( String, Float, Float, Int, Int ) -> Html msg
renderImage sunPosition direction ( url, distance, opacity, width, height ) =
    let
        flareVector =
            Debug.log "flareVector: " <| Vec2.scale distance direction

        position =
            Debug.log "position: " <| Vec2.add sunPosition flareVector
    in
    Html.div
        [ Attr.style
            [ ( "background-image", "url('" ++ url ++ "')" )
            , ( "background-size", "cover" )
            , ( "position", "absolute" )
            , ( "opacity", toString opacity )
            , ( "left", toString (Vec2.getX position - toFloat width / 2) ++ "px" )
            , ( "top", toString (Vec2.getY position - toFloat height / 2) ++ "px" )
            , ( "width", toString width ++ "px" )
            , ( "height", toString height ++ "px" )
            , ( "z-index", "1" )
            ]
        ]
        []


midViewport : Size -> Vec2
midViewport viewport =
    Vec2.vec2 (toFloat viewport.width / 2) (toFloat viewport.height / 2)
