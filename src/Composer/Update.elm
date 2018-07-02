module Composer.Update exposing (subscriptions, update)

{-| Module implementing the composed message handling for the complete application.
-}

import Composer.Model exposing (Model, Msg)


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
