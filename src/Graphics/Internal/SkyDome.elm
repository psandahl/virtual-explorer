module Graphics.Internal.SkyDome
    exposing
        ( Vertex
        , fragmentShader
        , makeMesh
        , vertexShader
        )

{-| Implementation of a SkyDome.
-}

import Graphics.Internal.IcoSphere as IcoSphere
import Math.Matrix4 exposing (Mat4)
import Math.Vector3 as Vec3 exposing (Vec3)
import WebGL as GL exposing (Mesh, Shader)


{-| Vertex type.
-}
type alias Vertex =
    { aPosition : Vec3
    }


{-| Make a SkyDome mesh.
-}
makeMesh : Mesh Vertex
makeMesh =
    GL.triangles <| List.map toVertex <| IcoSphere.icosphere 3


{-| The SkyDome's vertex shader. Just doing translations.
-}
vertexShader :
    Shader Vertex
        { uniforms
            | uViewMatrix : Mat4
            , uProjectionMatrix : Mat4
        }
        { vPosition : Vec3 }
vertexShader =
    [glsl|
precision mediump float;

attribute vec3 aPosition;

uniform mat4 uViewMatrix;
uniform mat4 uProjectionMatrix;

varying vec3 vPosition;

void main()
{
    vPosition = aPosition;

    // Lower the dome a little bit.
    mat4 modelMatrix = mat4(1.0);
    modelMatrix[3][1] = -0.2;

    // Remove translation part of view matrix.
    mat4 viewMatrix = mat4(uViewMatrix[0], uViewMatrix[1], uViewMatrix[2], vec4(0.0, 0.0, 0.0, 1.0));
    gl_Position = (uProjectionMatrix * viewMatrix * modelMatrix) * vec4(aPosition, 1.0);
}
    |]


{-| SkyDome's fragment shader. Doing the coloring.
-}
fragmentShader :
    Shader {}
        { uniforms
            | uSky0 : Vec3
            , uSky1 : Vec3
            , uFog : Vec3
        }
        { vPosition : Vec3 }
fragmentShader =
    [glsl|
precision mediump float;

uniform vec3 uSky0;
uniform vec3 uSky1;
uniform vec3 uFog;

varying vec3 vPosition;

void main()
{
    float offset = abs(vPosition.y);
    vec3 skyGradient = mix(uSky0, uSky1, offset);
    vec3 fogMixed = mix(uFog, skyGradient, smoothstep(0.0, 0.3, offset));

    gl_FragColor = vec4(fogMixed, 1.0);
}
    |]


toVertex : ( Vec3, Vec3, Vec3 ) -> ( Vertex, Vertex, Vertex )
toVertex ( v0, v1, v2 ) =
    ( { aPosition = v0 }, { aPosition = v1 }, { aPosition = v2 } )
