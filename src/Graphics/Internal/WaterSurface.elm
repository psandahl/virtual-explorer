module Graphics.Internal.WaterSurface
    exposing
        ( Vertex
        , fragmentShader
        , makeMesh
        , vertexShader
        )

{-| Implementation of a WaterSurface.
-}

import Settings
import Math.Matrix4 exposing (Mat4)
import Math.Vector3 as Vec3 exposing (Vec3)
import WebGL as GL exposing (Mesh, Shader)


{-| Vertex type.
-}
type alias Vertex =
    { aPosition : Vec3 }


{-| Make a square with the size given by the Settings.
The height is initially zero.
-}
makeMesh : Mesh Vertex
makeMesh =
    let
        away =
            toFloat Settings.verticeCount
                * Settings.scaleFactor
                * toFloat Settings.tileCount

        vertices =
            [ { aPosition = Vec3.vec3 -away 0 -away }
            , { aPosition = Vec3.vec3 away 0 -away }
            , { aPosition = Vec3.vec3 -away 0 away }
            , { aPosition = Vec3.vec3 away 0 away }
            ]

        indices =
            [ ( 1, 0, 2 ), ( 1, 2, 3 ) ]
    in
        GL.indexedTriangles vertices indices


{-| WaterSurface's vertex shader. Just doing transformations.
-}
vertexShader :
    Shader Vertex
        { uniforms
            | uViewMatrix : Mat4
            , uProjectionMatrix : Mat4
            , uHeight : Float
        }
        {}
vertexShader =
    [glsl|
precision mediump float;

attribute vec3 aPosition;

uniform mat4 uViewMatrix;
uniform mat4 uProjectionMatrix;
uniform float uHeight;

void main()
{
    // Adjust the height.
    mat4 modelMatrix = mat4(1.0);
    modelMatrix[3][1] = uHeight;

    mat4 mvp = uProjectionMatrix * uViewMatrix * modelMatrix;

    gl_Position = mvp * vec4(aPosition, 1.0);
}

    |]


{-| WaterSurface's fragment shader.
-}
fragmentShader :
    Shader {}
        { uniforms
            | uColor : Vec3
            , uTransparancy : Float
        }
        {}
fragmentShader =
    [glsl|
precision mediump float;

uniform vec3 uColor;
uniform float uTransparancy;

void main()
{
    gl_FragColor = vec4(uColor, uTransparancy);
}
    |]
