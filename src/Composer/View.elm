module Composer.View exposing (view)

{-| Module implementing the composed view for the complete application.
-}

import Compass.View as Compass
import Composer.Model exposing (Model, Msg)
import Graphics.View as Graphics
import Html exposing (Html)


{-| Top rendering function.
-}
view : Model -> Html Msg
view model =
    Html.div []
        [ Graphics.view model.graphics
        , Compass.view model.compass
        ]
