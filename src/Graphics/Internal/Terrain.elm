module Graphics.Internal.Terrain
    exposing
        ( Vertex
        , makeMesh
        , dimensions
        , vertexShader
        , fragmentShader
        )

{-| Module implementing the terrain graphics; generating the mesh and providing
the shaders for rendering the terrain.

The terrain itself is just a flat terrain tile. The only attribute for the
mesh is the position; the x components goes from 0 to dimensions vertices,
the z components goes from 0 to dimensions vertices. Y components are constant 0.
The height is then generated in the vertex shader.

The dimensions are quite small, because of limitations in the Elm runtime. If
the dimensions are to big there will be stack overruns because of too much
recursion.

-}

import List.Extra as List
import Math.Matrix4 exposing (Mat4)
import Math.Vector2 exposing (Vec2)
import Math.Vector3 as Vec3 exposing (Vec3)
import WebGL as GL exposing (Mesh, Shader)


{-| Terrain vertex type.
-}
type alias Vertex =
    { aPosition : Vec3
    }


{-| Make a mesh with the dimensions configured by 'dimensions'.
-}
makeMesh : Mesh Vertex
makeMesh =
    let
        vertices =
            makeVertices dimensions

        indices =
            makeIndices dimensions
    in
        GL.indexedTriangles vertices indices


{-| Give the vertice count dimensions for a tile. (x, z).
-}
dimensions : ( Int, Int )
dimensions =
    ( 65, 65 )


{-| Make vertices for the given dimensions.
-}
makeVertices : ( Int, Int ) -> List Vertex
makeVertices ( cols, rows ) =
    List.initialize (cols * rows) <|
        \vertice ->
            let
                x =
                    vertice % cols

                z =
                    vertice // cols
            in
                { aPosition = Vec3.vec3 (toFloat x) 0 (toFloat z) }


{-| Make triangle indices for the given dimensions
-}
makeIndices : ( Int, Int ) -> List ( Int, Int, Int )
makeIndices ( cols, rows ) =
    -- Convert vertices count to quad count, and then to triangle count ...
    List.initialize ((cols - 1) * (rows - 1) * 2) <|
        \triangle ->
            let
                quad =
                    triangle // 2

                row =
                    quad // (rows - 1)

                col =
                    quad % (cols - 1)

                v0 =
                    col + (row * cols)

                v1 =
                    v0 + 1

                v2 =
                    col + ((row + 1) * cols)

                v3 =
                    v2 + 1
            in
                if isEven triangle then
                    ( v1, v0, v2 )
                else
                    ( v1, v2, v3 )


isEven : Int -> Bool
isEven n =
    n % 2 == 0



{-
   Vertex shader contains code from:
   Description : Array and textureless GLSL 2D simplex noise function.
        Author : Ian McEwan, Ashima Arts.
    Maintainer : stegu
       Lastmod : 20110822 (ijm)
       License : Copyright (C) 2011 Ashima Arts. All rights reserved.
                 Distributed under the MIT License. See LICENSE file.
                 https://github.com/ashima/webgl-noise
                 https://github.com/stegu/webgl-noise
-}


{-| Vertex shader for the terrain.
-}
vertexShader :
    Shader Vertex
        { uniforms
            | uModelMatrix : Mat4
            , uViewMatrix : Mat4
            , uProjectionMatrix : Mat4
            , uWorldOffset : Vec2
            , uOctave0WaveLength : Int
            , uOctave0Altitude : Int
            , uColor0 : Vec3
            , uAmbientLightColor : Vec3
            , uAmbientLightStrength : Float
            , uSunLightColor : Vec3
            , uSunLightDirection : Vec3
        }
        { vColor : Vec3 }
vertexShader =
    [glsl|
precision mediump float;

// Single attribute: the vertex position.
attribute vec3 aPosition;

// Transformation matrices.
uniform mat4 uModelMatrix;
uniform mat4 uViewMatrix;
uniform mat4 uProjectionMatrix;

// Terrain shaping uniforms.
uniform vec2 uWorldOffset;

uniform int uOctave0WaveLength;
uniform int uOctave0Altitude;

// Color uniforms.
uniform vec3 uColor0;

// Lightning uniforms.
uniform vec3 uAmbientLightColor;
uniform float uAmbientLightStrength;

uniform vec3 uSunLightColor;
uniform vec3 uSunLightDirection;

// The color produced for the vertex.
varying vec3 vColor;

// Calculate the vertex color.
vec3 vertexColor();

// Calculate the ambient light.
vec3 ambientLight();

// Functions for the implementation of simple noise.
vec3 mod289(vec3 x);
vec2 mod289(vec2 x);
vec3 permute(vec3 x);
float snoise(vec2 v);

void main()
{
    vColor = vertexColor() * ambientLight();

    mat4 mvp = uProjectionMatrix * uViewMatrix * uModelMatrix;
    gl_Position = mvp * vec4(aPosition, 1.0);
}

vec3 vertexColor()
{
    return uColor0;
}

vec3 ambientLight()
{
    return uAmbientLightColor * uAmbientLightStrength;
}

vec3 mod289(vec3 x) {
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec2 mod289(vec2 x) {
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec3 permute(vec3 x) {
  return mod289(((x*34.0)+1.0)*x);
}

float snoise(vec2 v)
{
  const vec4 C = vec4(0.211324865405187,  // (3.0-sqrt(3.0))/6.0
                      0.366025403784439,  // 0.5*(sqrt(3.0)-1.0)
                     -0.577350269189626,  // -1.0 + 2.0 * C.x
                      0.024390243902439); // 1.0 / 41.0
// First corner
  vec2 i  = floor(v + dot(v, C.yy) );
  vec2 x0 = v -   i + dot(i, C.xx);

// Other corners
  vec2 i1;
  //i1.x = step( x0.y, x0.x ); // x0.x > x0.y ? 1.0 : 0.0
  //i1.y = 1.0 - i1.x;
  i1 = (x0.x > x0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
  // x0 = x0 - 0.0 + 0.0 * C.xx ;
  // x1 = x0 - i1 + 1.0 * C.xx ;
  // x2 = x0 - 1.0 + 2.0 * C.xx ;
  vec4 x12 = x0.xyxy + C.xxzz;
  x12.xy -= i1;

// Permutations
  i = mod289(i); // Avoid truncation effects in permutation
  vec3 p = permute( permute( i.y + vec3(0.0, i1.y, 1.0 ))
		+ i.x + vec3(0.0, i1.x, 1.0 ));

  vec3 m = max(0.5 - vec3(dot(x0,x0), dot(x12.xy,x12.xy), dot(x12.zw,x12.zw)), 0.0);
  m = m*m ;
  m = m*m ;

// Gradients: 41 points uniformly over a line, mapped onto a diamond.
// The ring size 17*17 = 289 is close to a multiple of 41 (41*7 = 287)

  vec3 x = 2.0 * fract(p * C.www) - 1.0;
  vec3 h = abs(x) - 0.5;
  vec3 ox = floor(x + 0.5);
  vec3 a0 = x - ox;

// Normalise gradients implicitly by scaling m
// Approximation of: m *= inversesqrt( a0*a0 + h*h );
  m *= 1.79284291400159 - 0.85373472095314 * ( a0*a0 + h*h );

// Compute final noise value at P
  vec3 g;
  g.x  = a0.x  * x0.x  + h.x  * x0.y;
  g.yz = a0.yz * x12.xz + h.yz * x12.yw;
  return 130.0 * dot(m, g);
}

    |]


{-| Fragment shader for the terrain. Extremely simple.
-}
fragmentShader : Shader {} uniforms { vColor : Vec3 }
fragmentShader =
    [glsl|
precision mediump float;

varying vec3 vColor;

void main()
{
    gl_FragColor = vec4(vColor, 1.0);
}
    |]
