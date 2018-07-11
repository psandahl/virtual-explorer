module Composer.View exposing (view)

{-| Module implementing the composed view for the complete application.
-}

import Camera.Update as Camera
import Compass.View as Compass
import Composer.Model exposing (Model, Msg)
import Graphics.View as Graphics
import ToolBox.View as ToolBox
import Html exposing (Html)


{-| Top rendering function.
-}
view : Model -> Html Msg
view model =
    Html.div []
        [ ToolBox.view model.toolBox
        , Graphics.view model.camera model.toolBox model.graphics
        , Compass.view model.camera.heading model.compass
        ]
