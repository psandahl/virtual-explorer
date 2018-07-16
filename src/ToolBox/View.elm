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
        ]


octaveSliderGroup : String -> List ( Slider, Int, Int, Int ) -> Html Msg
octaveSliderGroup caption sliders =
    Html.div
        [ Attr.style
            [ ( "width", "95%" )
            , ( "margin-top", "5px" )
            , ( "margin-left", "1%" )
            , ( "border", "2px solid gray" )
            , ( "border-radius", "5px" )
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
                        , Attr.class "slider"
                        , onSliderChange slider
                        ]
                        []
                )
                sliders


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
