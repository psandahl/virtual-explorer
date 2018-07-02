module Graphics.View exposing (view)

{-| Module implementing the main rendering functionality for the graphics view.
-}

import Composer.Model exposing (Msg)
import Graphics.Model exposing (Model)
import Html exposing (Html)
import Html.Attributes as Attr
import WebGL as GL


{-| Main view function for the graphics view.
-}
view : Model -> Html Msg
view model =
    GL.toHtmlWith
        [ GL.antialias
        , GL.depth 1
        , GL.alpha False
        , GL.clearColor (135.0 / 255.0) (206.0 / 255.0) (235.0 / 255.0) 1
        ]
        [ Attr.height model.viewport.height
        , Attr.width model.viewport.width
        ]
        []
