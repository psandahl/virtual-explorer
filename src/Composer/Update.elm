module Composer.Update exposing (init, subscriptions, update)

{-| Module implementing the composed message handling for the complete application.
-}

import Composer.Model exposing (Model, Msg)
import Graphics.Update as Graphics


{-| Initialize the model.
-}
init : ( Model, Cmd Msg )
init =
    ( { graphics = Graphics.init }, Cmd.none )


{-| The main update function for the complete application.
-}
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


{-| Handle subscriptions for the application.
-}
subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
