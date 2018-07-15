module Composer.Update exposing (init, subscriptions, update)

{-| Module implementing the composed message handling for the complete application.
-}

import Camera.Update as Camera
import Compass.Update as Compass
import Composer.Model exposing (Model, Msg(..))
import Debug
import Graphics.Model exposing (Cursor(..))
import Graphics.Update as Graphics
import Keyboard exposing (KeyCode)
import Mouse exposing (Position)
import Task
import ToolBox.Update as ToolBox
import Window exposing (Size)


{-| Initialize the model.
-}
init : ( Model, Cmd Msg )
init =
    let
        camera =
            Camera.init defaultViewport
    in
    ( { graphics = Graphics.init defaultViewport camera
      , compass = Compass.init defaultViewport
      , camera = camera
      , toolBox = ToolBox.init
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
                | graphics =
                    Graphics.pageTiles model.camera <|
                        Graphics.setViewport viewport model.graphics
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
                    case model.ctrlKeyDown of
                        True ->
                            let
                                camera =
                                    Camera.mouseRotateCamera from to model.camera
                            in
                            ( { model
                                | trackedMousePosition = Just to
                                , camera = camera
                                , graphics =
                                    Graphics.pageTiles camera <|
                                        Graphics.setCursor (cursorType model.ctrlKeyDown <| Just to) model.graphics
                              }
                            , Cmd.none
                            )

                        False ->
                            ( { model
                                | trackedMousePosition = Just to
                                , camera = Camera.mouseMoveWorldOffset from to model.camera
                                , graphics = Graphics.setCursor (cursorType model.ctrlKeyDown <| Just to) model.graphics
                              }
                            , Cmd.none
                            )

                Nothing ->
                    debugLog "Mouse released without having a tracked position. Unexpeced" model

        GraphicsViewMouseReleased to ->
            case model.trackedMousePosition of
                Just from ->
                    case model.ctrlKeyDown of
                        True ->
                            let
                                camera =
                                    Camera.mouseRotateCamera from to model.camera
                            in
                            ( { model
                                | trackedMousePosition = Nothing
                                , camera = camera
                                , graphics =
                                    Graphics.pageTiles camera <|
                                        Graphics.setCursor (cursorType model.ctrlKeyDown Nothing) model.graphics
                              }
                            , Cmd.none
                            )

                        False ->
                            ( { model
                                | trackedMousePosition = Nothing
                                , camera = Camera.mouseMoveWorldOffset from to model.camera
                                , graphics = Graphics.setCursor (cursorType model.ctrlKeyDown Nothing) model.graphics
                              }
                            , Cmd.none
                            )

                Nothing ->
                    debugLog "Mouse released without having a tracked position. Unexpected" model

        OpenToolBox ->
            ( { model | toolBox = ToolBox.openToolBox model.toolBox }, Cmd.none )

        CloseToolBox ->
            ( { model | toolBox = ToolBox.closeToolBox model.toolBox }, Cmd.none )

        ToolBoxSliderChange slider value ->
            ( { model | toolBox = ToolBox.setSliderValue slider value model.toolBox }, Cmd.none )

        Nop ->
            ( model, Cmd.none )


{-| Handle subscriptions for the application.
-}
subscriptions : Model -> Sub Msg
subscriptions model =
    let
        baseSubscriptions =
            [ Window.resizes SetViewport
            , Keyboard.downs keyDownHandler
            , Keyboard.ups keyUpHandler
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


keyDownHandler : KeyCode -> Msg
keyDownHandler keyCode =
    if keyCode == 17 then
        CtrlKeyDown
    else
        Nop


keyUpHandler : KeyCode -> Msg
keyUpHandler keyCode =
    if keyCode == 17 then
        CtrlKeyUp
    else if keyCode == 27 then
        CloseToolBox
    else
        Nop


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


debugLog : String -> Model -> ( Model, Cmd Msg )
debugLog str model =
    let
        dgb =
            Debug.log str
    in
    ( model, Cmd.none )
