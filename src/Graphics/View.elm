module Graphics.View exposing (view)

{-| Module implementing the main rendering functionality for the graphics view.
-}

import Camera.Model as Camera
import Composer.Model exposing (Msg(..))
import Graphics.Internal.TerrainPager as TerrainPager exposing (Tile)
import Graphics.Internal.Terrain as Terrain
import Graphics.Model exposing (Model, Cursor(..))
import Html exposing (Attribute, Html)
import Html.Attributes as Attr
import Html.Events as Events
import Json.Decode as Decode
import Mouse
import ToolBox.Model as ToolBox
import WebGL as GL
import WebGL.Settings as Settings
import WebGL.Settings.DepthTest as DepthTest


{-| Main view function for the graphics view.
-}
view : Camera.Model -> ToolBox.Model -> Model -> Html Msg
view camera toolBox model =
    GL.toHtmlWith
        [ GL.antialias
        , GL.depth 1
        , GL.alpha False
        , GL.clearColor (135.0 / 255.0) (206.0 / 255.0) (235.0 / 255.0) 1
        ]
        [ Attr.height model.viewport.height
        , Attr.width model.viewport.width
        , onMouseDown
        , Attr.style
            [ ( "cursor", cursorToString model.cursor )
            ]
        ]
    <|
        List.map
            (\tileModelMatrix ->
                GL.entityWith
                    [ DepthTest.default
                    , Settings.cullFace Settings.back
                    ]
                    Terrain.vertexShader
                    Terrain.fragmentShader
                    model.terrainMesh
                    { uProjectionMatrix = model.projectionMatrix
                    , uViewMatrix = camera.viewMatrix
                    , uModelMatrix = tileModelMatrix
                    , uWorldOffset = camera.worldOffset
                    , uOctave0HorizontalWaveLength = toolBox.octave0HorizontalWaveLength
                    , uOctave0VerticalWaveLength = toolBox.octave0VerticalWaveLength
                    , uOctave0Altitude = toolBox.octave0Altitude
                    , uColor0 = toolBox.color0
                    , uAmbientLightColor = toolBox.ambientLightColor
                    , uAmbientLightStrength = toolBox.ambientLightStrength
                    , uSunLightColor = toolBox.sunLightColor
                    , uSunLightDirection = toolBox.sunLightDirection
                    }
            )
        <|
            List.map
                (\tile -> tile.translationMatrix)
            <|
                (TerrainPager.page model.aspectRatio camera model.terrainPager)


onMouseDown : Attribute Msg
onMouseDown =
    Events.on "mousedown" <| Decode.map GraphicsViewMouseDown Mouse.position


cursorToString : Cursor -> String
cursorToString cursor =
    case cursor of
        Default ->
            "default"

        Move ->
            "move"

        Crosshair ->
            "crosshair"
