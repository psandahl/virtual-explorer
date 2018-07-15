module Composer.View exposing (view)

{-| Module implementing the composed view for the complete application.
-}

import Camera.Update as Camera
import Compass.View as Compass
import Composer.Model exposing (Model, Msg)
import Coordinate.View as Coordinate
import Graphics.View as Graphics
import Html exposing (Html)
import ToolBox.View as ToolBox


{-| Top rendering function.
-}
view : Model -> Html Msg
view model =
    Html.div []
        [ ToolBox.view model.toolBox
        , Graphics.view model.camera model.toolBox model.graphics
        , Coordinate.view (Camera.virtualPosition model.camera) model.coordinate
        , Compass.view model.camera.heading model.compass
        ]
