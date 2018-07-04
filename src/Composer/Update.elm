module Composer.Update exposing (init, subscriptions, update)

{-| Module implementing the composed message handling for the complete application.
-}

import Camera.Update as Camera
import Compass.Update as Compass
import Composer.Model exposing (Model, Msg(..))
import Graphics.Model exposing (Cursor(..))
import Graphics.Update as Graphics
import Keyboard exposing (KeyCode)
import Mouse exposing (Position)
import Task
import Window exposing (Size)
import Debug


{-| Initialize the model.
-}
init : ( Model, Cmd Msg )
init =
    ( { graphics = Graphics.init defaultViewport
      , compass = Compass.init defaultViewport
      , camera = Camera.init defaultViewport
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
            ( { model
                | graphics = Graphics.setViewport viewport model.graphics
                , compass = Compass.setViewport viewport model.compass
                , camera = Camera.setViewport viewport model.camera
              }
            , Cmd.none
            )

        CtrlKeyDown ->
            ( { model
                | ctrlKeyDown = True
                , graphics = Graphics.setCursor (cursorType True model.trackedMousePosition) model.graphics
              }
            , Cmd.none
            )

        CtrlKeyUp ->
            ( { model
                | ctrlKeyDown = False
                , graphics = Graphics.setCursor (cursorType False model.trackedMousePosition) model.graphics
              }
            , Cmd.none
            )

        GraphicsViewMouseDown position ->
            ( { model
                | trackedMousePosition = Just position
                , graphics = Graphics.setCursor (cursorType model.ctrlKeyDown <| Just position) model.graphics
              }
            , Cmd.none
            )

        GraphicsViewMouseMoved to ->
            case model.trackedMousePosition of
                Just from ->
                    ( { model
                        | trackedMousePosition = Just to
                        , camera =
                            case model.ctrlKeyDown of
                                True ->
                                    Camera.mouseRotateCamera from to model.camera

                                False ->
                                    Camera.mouseMovePosition from to model.camera
                        , graphics = Graphics.setCursor (cursorType model.ctrlKeyDown <| Just to) model.graphics
                      }
                    , Cmd.none
                    )

                Nothing ->
                    Debug.crash "Shall have a tracked position"

        GraphicsViewMouseReleased to ->
            case model.trackedMousePosition of
                Just from ->
                    ( { model
                        | trackedMousePosition = Nothing
                        , camera =
                            case model.ctrlKeyDown of
                                True ->
                                    Camera.mouseRotateCamera from to model.camera

                                False ->
                                    Camera.mouseMovePosition from to model.camera
                        , graphics = Graphics.setCursor (cursorType model.ctrlKeyDown Nothing) model.graphics
                      }
                    , Cmd.none
                    )

                Nothing ->
                    Debug.crash "Shall have a tracked position"

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


cursorType : Bool -> Maybe Position -> Cursor
cursorType ctrlKeyDown trackedMousePosition =
    case ( ctrlKeyDown, trackedMousePosition ) of
        ( True, Just _ ) ->
            Crosshair

        ( False, Just _ ) ->
            Move

        ( _, Nothing ) ->
            Default


{-| Give a default viewport before the browser reports the real one.
-}
defaultViewport : Size
defaultViewport =
    { width = 1024, height = 768 }
