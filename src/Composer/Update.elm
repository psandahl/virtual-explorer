module Composer.Update exposing (init, subscriptions, update)

{-| Module implementing the composed message handling for the complete application.
-}

import Compass.Update as Compass
import Composer.Model exposing (Model, Msg(..))
import Graphics.Update as Graphics
import Keyboard exposing (KeyCode)
import Mouse
import Task
import Window
import Debug


{-| Initialize the model.
-}
init : ( Model, Cmd Msg )
init =
    ( { graphics = Graphics.init
      , compass = Compass.init
      , ctrlKeyDown = False
      , trackedMousePosition = Nothing
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

        CtrlKeyDown ->
            ( { model | ctrlKeyDown = True }, Cmd.none )

        CtrlKeyUp ->
            ( { model | ctrlKeyDown = False }, Cmd.none )

        GraphicsViewMouseDown position ->
            ( model, Cmd.none )

        GraphicsViewMouseMoved position ->
            ( model, Cmd.none )

        GraphicsViewMouseReleased position ->
            ( model, Cmd.none )

        Nop ->
            ( model, Cmd.none )


{-| Handle subscriptions for the application.
-}
subscriptions : Model -> Sub Msg
subscriptions model =
    let
        baseSubscriptions =
            [ Window.resizes SetViewport
            , Keyboard.downs (ifCtrlKeyInsert CtrlKeyDown)
            , Keyboard.ups (ifCtrlKeyInsert CtrlKeyUp)
            ]

        mouseSubscriptions =
            [ Mouse.moves GraphicsViewMouseMoved
            , Mouse.ups GraphicsViewMouseReleased
            ]
    in
        Sub.batch <|
            case model.trackedMousePosition of
                Just _ ->
                    baseSubscriptions ++ mouseSubscriptions

                Nothing ->
                    baseSubscriptions


ifCtrlKeyInsert : Msg -> KeyCode -> Msg
ifCtrlKeyInsert msg keyCode =
    if isCtrlKeyCode keyCode then
        msg
    else
        Nop


isCtrlKeyCode : KeyCode -> Bool
isCtrlKeyCode keyCode =
    keyCode == 17
