module Graphics.View exposing (view)

{-| Module implementing the main rendering functionality for the graphics view.
-}

import Camera.Model as Camera
import Composer.Model exposing (Msg(..))
import Graphics.Internal.SkyDome as SkyDome
import Graphics.Internal.Terrain as Terrain
import Graphics.Model exposing (Cursor(..), Model)
import Html exposing (Attribute, Html)
import Html.Attributes as Attr
import Html.Events as Events
import Json.Decode as Decode
import Mouse
import Settings
import ToolBox.Model as ToolBox
import WebGL as GL exposing (Entity)
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
        skyDomeEntity camera toolBox model
            :: terrainEntities camera toolBox model


{-| Produce the SkyDome entity. Must be rendered first.
-}
skyDomeEntity : Camera.Model -> ToolBox.Model -> Model -> Entity
skyDomeEntity camera toolBox model =
    GL.entityWith
        [ DepthTest.always { write = False, near = 0, far = 1 }
        , Settings.cullFace Settings.front
        ]
        SkyDome.vertexShader
        SkyDome.fragmentShader
        model.skyDomeMesh
        { uProjectionMatrix = model.projectionMatrix
        , uViewMatrix = camera.viewMatrix
        , uSky0 = toolBox.sky0
        , uSky1 = toolBox.sky1
        , uFog = toolBox.fog
        }


{-| Produce all terrain entities.
-}
terrainEntities : Camera.Model -> ToolBox.Model -> Model -> List Entity
terrainEntities camera toolBox model =
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
                , uOctave1HorizontalWaveLength = toolBox.octave1HorizontalWaveLength
                , uOctave1VerticalWaveLength = toolBox.octave1VerticalWaveLength
                , uOctave1Altitude = toolBox.octave1Altitude
                , uOctave2HorizontalWaveLength = toolBox.octave2HorizontalWaveLength
                , uOctave2VerticalWaveLength = toolBox.octave2VerticalWaveLength
                , uOctave2Altitude = toolBox.octave2Altitude
                , uMaxTerrainAltitude = Settings.maxTerrainAltitude
                , uColor0 = toolBox.color0
                , uColor1 = toolBox.color1
                , uColor2 = toolBox.color2
                , uColor3 = toolBox.color3
                , uAmbientLightColor = toolBox.ambientLightColor
                , uAmbientLightStrength = toolBox.ambientLightStrength
                , uSunLightColor = toolBox.sunLightColor
                , uSunLightDirection = toolBox.sunLightDirection
                , uUseFog = toolBox.useFog
                , uFog = toolBox.fog
                , uFogPower = toolBox.fogPower
                , uFogDistance = Settings.farPlane
                , uCameraPosition = camera.position
                }
        )
    <|
        model.terrainPager.translationMatrices


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
