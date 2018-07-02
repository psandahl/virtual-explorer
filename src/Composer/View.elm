module Composer.View exposing (view)

{-| Module implementing the composed view for the complete application.
-}

import Composer.Model exposing (Model, Msg)
import Html exposing (Html)


{-| Top rendering function.
-}
view : Model -> Html Msg
view model =
    Html.text "Hepp"
