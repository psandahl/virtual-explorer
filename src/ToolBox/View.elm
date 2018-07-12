module ToolBox.View exposing (view)

{-| Module implementing the view for the ToolBox.
-}

import Char
import Composer.Model exposing (Msg(..))
import Html exposing (Html, Attribute)
import Html.Attributes as Attr
import Html.Events as Events
import Json.Decode as Decode
import Settings
import ToolBox.Model exposing (Model, State(..), Slider(..))


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
        , slider Octave0HorizontalWaveLength
            "Oct[0]: Horizontal length"
            1
            Settings.octave0MaxWaveLength
            model.octave0HorizontalWaveLength
        , slider Octave0VerticalWaveLength
            "Oct[0]: Vertical length"
            1
            Settings.octave0MaxWaveLength
            model.octave0VerticalWaveLength
        , slider Octave0Altitude
            "Oct[0]: Altitude"
            0
            Settings.octave0MaxAltitude
            model.octave0Altitude
        , slider Octave1HorizontalWaveLength
            "Oct[1]: Horizontal length"
            1
            Settings.octave1MaxWaveLength
            model.octave1HorizontalWaveLength
        , slider Octave1VerticalWaveLength
            "Oct[1]: Vertical length"
            1
            Settings.octave1MaxWaveLength
            model.octave1VerticalWaveLength
        , slider Octave1Altitude
            "Oct[1]: Altitude"
            0
            Settings.octave1MaxAltitude
            model.octave1Altitude
        , slider Octave2HorizontalWaveLength
            "Oct[2]: Horizontal length"
            1
            Settings.octave2MaxWaveLength
            model.octave2HorizontalWaveLength
        , slider Octave2VerticalWaveLength
            "Oct[2]: Vertical length"
            1
            Settings.octave2MaxWaveLength
            model.octave2VerticalWaveLength
        , slider Octave2Altitude
            "Oct[2]: Altitude"
            0
            Settings.octave2MaxAltitude
            model.octave2Altitude
        ]


slider : Slider -> String -> Int -> Int -> Int -> Html Msg
slider slider caption min max value =
    Html.div
        [ Attr.style
            [ ( "width", "100%" )
            ]
        ]
        [ Html.span
            [ Attr.style
                [ ( "font-size", "12px" )
                , ( "font-family", "sans-serif" )
                , ( "color", "white" )
                , ( "margin-left", "5%" )
                ]
            ]
            [ Html.text <| caption ++ " (value: " ++ toString value ++ ")"
            , Html.input
                [ Attr.type_ "range"
                , Attr.min <| toString min
                , Attr.max <| toString max
                , Attr.value <| toString value
                , Attr.style
                    [ ( "width", "90%" )
                    , ( "height", "15px" )
                    , ( "margin-left", "5%" )
                    ]
                , onSliderChange slider
                ]
                []
            ]
        ]


onSliderChange : Slider -> Attribute Msg
onSliderChange slider =
    Events.on "input"
        (Decode.map
            (\x ->
                String.toInt x
                    |> Result.withDefault 0
                    |> ToolBoxSliderChange slider
            )
            Events.targetValue
        )
