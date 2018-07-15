module Coordinate.View exposing (view)

{-| Rendering of coordinate widget.
-}

import Composer.Model exposing (Msg)
import Coordinate.Model exposing (Model)
import Html exposing (Html)
import Html.Attributes as Attr
import Math.Vector3 as Vec3 exposing (Vec3)


{-| Render the coordinate widget. Flip sign for x and y to have things
more intuitive.
-}
view : Vec3 -> Model -> Html Msg
view coordinate model =
    Html.span
        [ Attr.style
            [ ( "position", "absolute" )
            , ( "right", "10px" )
            , ( "bottom", "10px" )
            , ( "font-family", "sans-serif" )
            , ( "font-size", "15px" )
            , ( "color", "white" )
            ]
        ]
        [ Html.text <|
            "(x: "
                ++ (toString <| round -(Vec3.getX coordinate))
                ++ ", y: "
                ++ (toString <| round -(Vec3.getY coordinate))
                ++ ", z: "
                ++ (toString <| round (Vec3.getZ coordinate))
                ++ ")"
        ]
