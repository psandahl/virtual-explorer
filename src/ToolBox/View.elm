module ToolBox.View exposing (view)

{-| Module implementing the view for the ToolBox.
-}

import Char
import Composer.Model exposing (Msg(..))
import Html exposing (Attribute, Html)
import Html.Attributes as Attr
import Html.Events as Events
import Json.Decode as Decode
import Math.Vector3 as Vec3 exposing (Vec3)
import Settings
import ToolBox.Model
    exposing
        ( ChangeFunction
        , Checkbox(..)
        , Model
        , SliderChange(..)
        , State(..)
        )


{-| The view function. Depending on state either the open button or the tool
box pane is rendered.
-}
view : Model -> Html Msg
view model =
    Html.div
        []
        [ if model.state == Closed then
            button
          else
            pane model
        ]


button : Html Msg
button =
    Html.span
        [ Attr.style
            [ ( "position", "absolute" )
            , ( "left", "10px" )
            , ( "top", "10px" )
            , ( "font-family", "sans-serif" )
            , ( "font-size", "30px" )
            , ( "cursor", "pointer" )
            ]
        , Events.onClick OpenToolBox
        ]
        [ Html.text <| String.fromChar <| Char.fromCode 9776
        ]


pane : Model -> Html Msg
pane model =
    Html.div
        [ Attr.style
            [ ( "display", "inline-block" )
            , ( "position", "fixed" )
            , ( "left", "0" )
            , ( "top", "0" )
            , ( "background-color", "rgba(88, 88, 88, 0.5)" )
            , ( "color", "white" )
            , ( "width", "250px" )
            , ( "height", "100%" )
            , ( "z-index", "1" )
            ]
        ]
        [ Html.span
            [ Attr.style
                [ ( "position", "absolute" )
                , ( "top", "0px" )
                , ( "right", "15px" )
                , ( "font-size", "30px" )
                , ( "cursor", "pointer" )
                , ( "font-family", "sans-serif" )
                ]
            , Events.onClick CloseToolBox
            ]
            [ Html.text <| String.fromChar <| Char.fromCode 215
            ]
        , Html.p [ Attr.style [ ( "margin-top", "35px" ) ] ] []
        , octaveSliderGroup "Octave0 horizontal/vertical/altitude"
            ( ( \model value -> { model | octave0 = Vec3.setX value model.octave0 }, 1, Settings.octave0MaxWaveLength )
            , ( \model value -> { model | octave0 = Vec3.setY value model.octave0 }, 1, Settings.octave0MaxWaveLength )
            , ( \model value -> { model | octave0 = Vec3.setZ value model.octave0 }, 0, Settings.octave0MaxAltitude )
            )
            model.octave0
        , octaveSliderGroup "Octave0 horizontal/vertical/altitude"
            ( ( \model value -> { model | octave1 = Vec3.setX value model.octave1 }, 1, Settings.octave1MaxWaveLength )
            , ( \model value -> { model | octave1 = Vec3.setY value model.octave1 }, 1, Settings.octave1MaxWaveLength )
            , ( \model value -> { model | octave1 = Vec3.setZ value model.octave1 }, 0, Settings.octave1MaxAltitude )
            )
            model.octave1
        , octaveSliderGroup "Octave0 horizontal/vertical/altitude"
            ( ( \model value -> { model | octave2 = Vec3.setX value model.octave2 }, 1, Settings.octave2MaxWaveLength )
            , ( \model value -> { model | octave2 = Vec3.setY value model.octave2 }, 1, Settings.octave2MaxWaveLength )
            , ( \model value -> { model | octave2 = Vec3.setZ value model.octave2 }, 0, Settings.octave2MaxAltitude )
            )
            model.octave2
        , colorSliderGroup "Color0 r/g/b"
            ( \model value -> { model | color0 = Vec3.setX (value / 255.0) model.color0 }
            , \model value -> { model | color0 = Vec3.setY (value / 255.0) model.color0 }
            , \model value -> { model | color0 = Vec3.setZ (value / 255.0) model.color0 }
            )
            model.color0
        , colorSliderGroup "Color1 r/g/b"
            ( \model value -> { model | color1 = Vec3.setX (value / 255.0) model.color1 }
            , \model value -> { model | color1 = Vec3.setY (value / 255.0) model.color1 }
            , \model value -> { model | color1 = Vec3.setZ (value / 255.0) model.color1 }
            )
            model.color1
        , colorSliderGroup "Color2 r/g/b"
            ( \model value -> { model | color2 = Vec3.setX (value / 255.0) model.color2 }
            , \model value -> { model | color2 = Vec3.setY (value / 255.0) model.color2 }
            , \model value -> { model | color2 = Vec3.setZ (value / 255.0) model.color2 }
            )
            model.color2
        , colorSliderGroup "Color3 r/g/b"
            ( \model value -> { model | color3 = Vec3.setX (value / 255.0) model.color3 }
            , \model value -> { model | color3 = Vec3.setY (value / 255.0) model.color3 }
            , \model value -> { model | color3 = Vec3.setZ (value / 255.0) model.color3 }
            )
            model.color3
        , fogControlGroup model
        , waterControlGroup model
        ]


octaveSliderGroup :
    String
    -> ( ( ChangeFunction, Float, Float ), ( ChangeFunction, Float, Float ), ( ChangeFunction, Float, Float ) )
    -> Vec3
    -> Html Msg
octaveSliderGroup caption ( ( cf0, min0, max0 ), ( cf1, min1, max1 ), ( cf2, min2, max2 ) ) values =
    let
        horizontal =
            Vec3.getX values

        vertical =
            Vec3.getY values

        altitude =
            Vec3.getZ values
    in
    Html.div
        [ Attr.style
            [ ( "width", "95%" )
            , ( "margin-top", "5px" )
            , ( "margin-left", "1%" )
            , ( "border", "2px solid gray" )
            , ( "border-radius", "5px" )
            , ( "line-height", "80%" )
            ]
        ]
    <|
        Html.span
            [ Attr.style
                [ ( "font-size", "12px" )
                , ( "font-family", "sans-serif" )
                , ( "color", "white" )
                , ( "margin-left", "2.5%" )
                ]
            ]
            [ Html.text caption ]
            :: List.map
                (\( changeFunction, min, max, value ) ->
                    Html.input
                        [ Attr.type_ "range"
                        , Attr.min <| toString min
                        , Attr.max <| toString max
                        , Attr.value <| toString value
                        , Attr.step "1.0"
                        , Attr.class "slider"
                        , onSliderChange <| Change changeFunction
                        ]
                        []
                )
                [ ( cf0, min0, max0, horizontal )
                , ( cf1, min1, max1, vertical )
                , ( cf2, min2, max2, altitude )
                ]


colorSliderGroup : String -> ( ChangeFunction, ChangeFunction, ChangeFunction ) -> Vec3 -> Html Msg
colorSliderGroup caption ( g0, g1, g2 ) color =
    let
        r =
            round <| Vec3.getX color * 255

        g =
            round <| Vec3.getY color * 255

        b =
            round <| Vec3.getZ color * 255
    in
    Html.div
        [ Attr.style
            [ ( "width", "95%" )
            , ( "margin-top", "5px" )
            , ( "margin-left", "1%" )
            , ( "border", "2px solid gray" )
            , ( "border-radius", "5px" )
            , ( "line-height", "80%" )
            ]
        ]
    <|
        Html.span
            [ Attr.style
                [ ( "font-size", "12px" )
                , ( "font-family", "sans-serif" )
                , ( "color", "white" )
                , ( "margin-left", "2.5%" )
                ]
            ]
            [ Html.text caption
            , Html.div
                [ Attr.style
                    [ ( "width", "40%" )
                    , ( "height", "15px" )
                    , ( "float", "right" )
                    , ( "margin-right", "1%" )
                    , ( "border", "1px solid black" )
                    , ( "background", rgb r g b )
                    ]
                ]
                []
            ]
            :: List.map
                (\( changeFunction, min, max, value ) ->
                    Html.input
                        [ Attr.type_ "range"
                        , Attr.min <| toString min
                        , Attr.max <| toString max
                        , Attr.value <| toString value
                        , Attr.step "1.0"
                        , Attr.class "slider"
                        , onSliderChange <| Change changeFunction
                        ]
                        []
                )
                [ ( g0, 0, 255, r ), ( g1, 0, 255, g ), ( g2, 0, 255, b ) ]


fogControlGroup : Model -> Html Msg
fogControlGroup model =
    Html.div
        [ Attr.style
            [ ( "width", "95%" )
            , ( "margin-top", "5px" )
            , ( "margin-left", "1%" )
            , ( "border", "2px solid gray" )
            , ( "border-radius", "5px" )
            , ( "line-height", "80%" )
            ]
        ]
        [ Html.span
            [ Attr.style
                [ ( "font-size", "12px" )
                , ( "font-family", "sans-serif" )
                , ( "color", "white" )
                , ( "margin-left", "2.5%" )
                ]
            ]
            [ Html.text "Fog Control" ]
        , Html.p [] []
        , Html.input
            [ Attr.type_ "checkbox"
            , Attr.style
                [ ( "margin-left", "2.5%" )
                ]
            , Attr.checked model.useFog
            , Events.onClick <| ToolBoxCheckboxToggle UseFog
            ]
            []
        , Html.input
            [ Attr.style
                [ ( "float", "right" )
                , ( "width", "80%" )
                , ( "margin-right", "2.5%" )
                , ( "margin-top", "3%" )
                ]
            , Attr.type_ "range"
            , Attr.min <| toString 1.0
            , Attr.max <| toString 10.0
            , Attr.value <| toString model.fogPower
            , Attr.step "0.1"
            , Attr.class "slider"
            , onSliderChange <| Change (\model value -> { model | fogPower = value })
            ]
            []
        ]


waterControlGroup : Model -> Html Msg
waterControlGroup model =
    Html.div
        [ Attr.style
            [ ( "width", "95%" )
            , ( "margin-top", "5px" )
            , ( "margin-left", "1%" )
            , ( "border", "2px solid gray" )
            , ( "border-radius", "5px" )
            , ( "line-height", "80%" )
            ]
        ]
        [ Html.span
            [ Attr.style
                [ ( "font-size", "12px" )
                , ( "font-family", "sans-serif" )
                , ( "color", "white" )
                , ( "margin-left", "2.5%" )
                ]
            ]
            [ Html.text "Water surface height/opacity"
            ]
        , Html.input
            [ Attr.type_ "range"
            , Attr.min <| toString -Settings.maxTerrainAltitude
            , Attr.max <| toString Settings.maxTerrainAltitude
            , Attr.value <| toString model.waterHeight
            , Attr.step "1.0"
            , Attr.class "slider"
            , onSliderChange <| Change (\model value -> { model | waterHeight = value })
            ]
            []
        , Html.input
            [ Attr.type_ "range"
            , Attr.min "0.0"
            , Attr.max "1.0"
            , Attr.value <| toString model.waterOpacity
            , Attr.step "0.05"
            , Attr.class "slider"
            , onSliderChange <| Change (\model value -> { model | waterOpacity = value })
            ]
            []
        ]


rgb : Int -> Int -> Int -> String
rgb r g b =
    "rgb("
        ++ toString r
        ++ ","
        ++ toString g
        ++ ","
        ++ toString b
        ++ ")"


onSliderChange : SliderChange -> Attribute Msg
onSliderChange sliderChange =
    Events.on "input"
        (Decode.map
            (\x ->
                String.toFloat x
                    |> Result.withDefault 0.0
                    |> ToolBoxSliderChange sliderChange
            )
            Events.targetValue
        )
