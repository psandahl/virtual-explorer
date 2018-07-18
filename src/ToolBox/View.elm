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
import ToolBox.Model exposing (Checkbox(..), Model, Slider(..), State(..))


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
            [ ( Octave0HorizontalWaveLength
              , 1
              , Settings.octave0MaxWaveLength
              , model.octave0HorizontalWaveLength
              )
            , ( Octave0VerticalWaveLength
              , 1
              , Settings.octave0MaxWaveLength
              , model.octave0VerticalWaveLength
              )
            , ( Octave0Altitude
              , 0
              , Settings.octave0MaxAltitude
              , model.octave0Altitude
              )
            ]
        , octaveSliderGroup "Octave1 horizontal/vertical/altitude"
            [ ( Octave1HorizontalWaveLength
              , 1
              , Settings.octave1MaxWaveLength
              , model.octave1HorizontalWaveLength
              )
            , ( Octave1VerticalWaveLength
              , 1
              , Settings.octave1MaxWaveLength
              , model.octave1VerticalWaveLength
              )
            , ( Octave1Altitude
              , 0
              , Settings.octave1MaxAltitude
              , model.octave1Altitude
              )
            ]
        , octaveSliderGroup "Octave2 horizontal/vertical/altitude"
            [ ( Octave2HorizontalWaveLength
              , 1
              , Settings.octave2MaxWaveLength
              , model.octave2HorizontalWaveLength
              )
            , ( Octave2VerticalWaveLength
              , 1
              , Settings.octave2MaxWaveLength
              , model.octave2VerticalWaveLength
              )
            , ( Octave2Altitude
              , 0
              , Settings.octave2MaxAltitude
              , model.octave2Altitude
              )
            ]
        , colorSliderGroup "Color0 r/g/b" ( Color0R, Color0G, Color0B ) model.color0
        , colorSliderGroup "Color1 r/g/b" ( Color1R, Color1G, Color1B ) model.color1
        , colorSliderGroup "Color2 r/g/b" ( Color2R, Color2G, Color2B ) model.color2
        , colorSliderGroup "Color3 r/g/b" ( Color3R, Color3G, Color3B ) model.color3
        , fogControlGroup model
        ]


octaveSliderGroup : String -> List ( Slider, Float, Float, Float ) -> Html Msg
octaveSliderGroup caption sliders =
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
                (\( slider, min, max, value ) ->
                    Html.input
                        [ Attr.type_ "range"
                        , Attr.min <| toString min
                        , Attr.max <| toString max
                        , Attr.value <| toString value
                        , Attr.step "1.0"
                        , Attr.class "slider"
                        , onSliderChange slider
                        ]
                        []
                )
                sliders


colorSliderGroup : String -> ( Slider, Slider, Slider ) -> Vec3 -> Html Msg
colorSliderGroup caption ( s0, s1, s2 ) color =
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
                (\( slider, min, max, value ) ->
                    Html.input
                        [ Attr.type_ "range"
                        , Attr.min <| toString min
                        , Attr.max <| toString max
                        , Attr.value <| toString value
                        , Attr.step "1.0"
                        , Attr.class "slider"
                        , onSliderChange slider
                        ]
                        []
                )
                [ ( s0, 0, 255, r ), ( s1, 0, 255, g ), ( s2, 0, 255, b ) ]


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
            , onSliderChange FogPower
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


onSliderChange : Slider -> Attribute Msg
onSliderChange slider =
    Events.on "input"
        (Decode.map
            (\x ->
                String.toFloat x
                    |> Result.withDefault 0.0
                    |> ToolBoxSliderChange slider
            )
            Events.targetValue
        )
