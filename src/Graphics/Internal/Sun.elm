module Graphics.Internal.Sun exposing (sunWithFlares)

{-| A simple system to render sun with a simple lens flare effect.
-}

import Html exposing (Html)
import Html.Attributes as Attr
import Math.Matrix4 as Mat4 exposing (Mat4)
import Math.Vector2 as Vec2 exposing (Vec2)
import Math.Vector3 as Vec3 exposing (Vec3)
import Window exposing (Size)


{-| Render a sun with flares using projection matrix, view matrix and the sun's direction.
If the sun not is visible on the screen nothing is rendered. Occlusion is not
considered.
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
    in
    if isVisible ndc then
        makeSunWithFlares viewport ndc
    else
        []


makeSunWithFlares : Size -> Vec3 -> List (Html msg)
makeSunWithFlares viewport ndc =
    let
        sunPosition =
            sunScreenPosition viewport ndc

        midPosition =
            midViewport viewport

        sunVector =
            Vec2.sub midPosition sunPosition

        endPosition =
            Vec2.add midPosition sunVector

        distance =
            abs (Vec2.distance endPosition sunPosition)

        direction =
            Vec2.normalize <| Vec2.sub endPosition sunPosition
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
            Vec2.scale distance direction

        position =
            Vec2.add sunPosition flareVector
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


{-| Check if a ndc position is visible on the screen.
-}
isVisible : Vec3 -> Bool
isVisible ndc =
    inVisibleRange (Vec3.getX ndc)
        && inVisibleRange (Vec3.getY ndc)
        && inVisibleRange (Vec3.getZ ndc)


inVisibleRange : Float -> Bool
inVisibleRange x =
    x >= -1.0 && x < 1.0


{-| Convert the ndc position for the sun to a screen coordinate.
-}
sunScreenPosition : Size -> Vec3 -> Vec2
sunScreenPosition viewport ndc =
    Vec2.vec2 (toFloat viewport.width * (Vec3.getX ndc * 0.5 + 0.5)) (toFloat viewport.height * (1.0 - (Vec3.getY ndc * 0.5 + 0.5)))


{-| Get the mid screen coordinate from the viewport size.
-}
midViewport : Size -> Vec2
midViewport viewport =
    Vec2.vec2 (toFloat viewport.width / 2) (toFloat viewport.height / 2)
