module Composer.Update exposing (init, subscriptions, update)

{-| Module implementing the composed message handling for the complete application.
-}

import Compass.Update as Compass
import Composer.Model exposing (Model, Msg(..))
import Graphics.Update as Graphics
import Task
import Window


{-| Initialize the model.
-}
init : ( Model, Cmd Msg )
init =
    ( { graphics = Graphics.init
      , compass = Compass.init
      }
    , Task.perform SetViewport Window.size
    )


{-| The main update function for the complete application.
-}
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetViewport viewport ->
            ( { model | graphics = Graphics.setViewport viewport model.graphics }
            , Cmd.none
            )


{-| Handle subscriptions for the application.
-}
subscriptions : Model -> Sub Msg
subscriptions model =
    Window.resizes SetViewport
