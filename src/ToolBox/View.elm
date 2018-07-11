module ToolBox.View exposing (view)

{-| Module implementing the view for the ToolBox.
-}

import Char
import Composer.Model exposing (Msg(..))
import Html exposing (Html, Attribute)
import Html.Attributes as Attr
import Html.Events as Events
import Json.Decode as Decode
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
        , slider Octave0WaveLength "Octave0: Wave length" 1 1024 model.octave0WaveLength
        , slider Octave0Altitude "Octave0: Altitude" 1 100 model.octave0Altitude
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
    Events.on "input" (Decode.map (\x -> String.toInt x |> Result.withDefault 0 |> ToolBoxSliderChange slider) Events.targetValue)
