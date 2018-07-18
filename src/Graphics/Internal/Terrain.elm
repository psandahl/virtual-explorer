module Graphics.Internal.Terrain
    exposing
        ( Vertex
        , dimensions
        , fragmentShader
        , makeMesh
        , vertexShader
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
    ( 256, 256 )


{-| Make vertices for the given dimensions.
-}
makeVertices : ( Int, Int ) -> List Vertex
makeVertices ( cols, rows ) =
    List.concatMap
        (\row ->
            List.map
                (\col ->
                    { aPosition = Vec3.vec3 (toFloat col) 0 (toFloat row) }
                )
            <|
                List.range 0 (cols - 1)
        )
    <|
        List.range 0 (rows - 1)


{-| Make triangle indices for the given dimensions
-}
makeIndices : ( Int, Int ) -> List ( Int, Int, Int )
makeIndices ( cols, rows ) =
    List.concatMap
        (\row ->
            List.concatMap
                (\col ->
                    let
                        i0 =
                            row * cols + col

                        i1 =
                            i0 + 1

                        i2 =
                            (row + 1) * cols + col

                        i3 =
                            i2 + 1
                    in
                    [ ( i1, i0, i2 ), ( i1, i2, i3 ) ]
                )
            <|
                List.range 0 (cols - 2)
        )
    <|
        List.range 0 (rows - 2)



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
            , uOctave0HorizontalWaveLength : Float
            , uOctave0VerticalWaveLength : Float
            , uOctave0Altitude : Float
            , uOctave1HorizontalWaveLength : Float
            , uOctave1VerticalWaveLength : Float
            , uOctave1Altitude : Float
            , uOctave2HorizontalWaveLength : Float
            , uOctave2VerticalWaveLength : Float
            , uOctave2Altitude : Float
            , uMaxTerrainAltitude : Float
            , uColor0 : Vec3
            , uColor1 : Vec3
            , uColor2 : Vec3
            , uColor3 : Vec3
            , uAmbientLightColor : Vec3
            , uAmbientLightStrength : Float
            , uSunLightColor : Vec3
            , uSunLightDirection : Vec3
            , uFog : Vec3
            , uFogDistance : Float
            , uCameraPosition : Vec3
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

uniform float uOctave0HorizontalWaveLength;
uniform float uOctave0VerticalWaveLength;
uniform float uOctave0Altitude;

uniform float uOctave1HorizontalWaveLength;
uniform float uOctave1VerticalWaveLength;
uniform float uOctave1Altitude;

uniform float uOctave2HorizontalWaveLength;
uniform float uOctave2VerticalWaveLength;
uniform float uOctave2Altitude;

// Color uniforms.
uniform float uMaxTerrainAltitude;
uniform vec3 uColor0;
uniform vec3 uColor1;
uniform vec3 uColor2;
uniform vec3 uColor3;

// Lightning uniforms.
uniform vec3 uAmbientLightColor;
uniform float uAmbientLightStrength;

uniform vec3 uSunLightColor;
uniform vec3 uSunLightDirection;

// Fog uniforms.
uniform vec3 uFog;
uniform float uFogDistance;
uniform vec3 uCameraPosition;

// The color produced for the vertex.
varying vec3 vColor;

// Generate the height (y) value for the position x, z.
float generateHeight(vec3 position);

// Calculate the vertex color.
vec3 vertexColor(float height);

// Calculate the ambient light.
vec3 ambientLight();

// Calculate the sun light.
vec3 sunLight(vec3 normal);

// Functions for the implementation of simple noise.
vec3 mod289(vec3 x);
vec2 mod289(vec2 x);
vec3 permute(vec3 x);
float snoise(vec2 v);

void main()
{
    // Step 1. Transform the position to it's world coordinates. Needed
    // for the height value generation.
    vec3 currentPosition = (uModelMatrix * vec4(aPosition, 1.0)).xyz;

    // Step 2. Convert the world offset to a vec3.
    vec3 worldOffset = vec3(uWorldOffset.x, 0.0, uWorldOffset.y);

    // Step 3. Calculate heights for the current position as well as for
    // six neighbour vertices.
    vec3 v0 = currentPosition + vec3(0.0, 0.0, -1.0);
    v0.y = generateHeight(v0 + worldOffset);

    vec3 v1 = currentPosition + vec3(1.0, 0.0, -1.0);
    v1.y = generateHeight(v1 + worldOffset);

    vec3 v2 = currentPosition + vec3(-1.0, 0.0, 0.0);
    v2.y = generateHeight(v2 + worldOffset);

    vec3 v3 = currentPosition + vec3(1.0, 0.0, 0.0);
    v3.y = generateHeight(v3 + worldOffset);

    vec3 v4 = currentPosition + vec3(-1.0, 0.0, 1.0);
    v4.y = generateHeight(v4 + worldOffset);

    vec3 v5 = currentPosition + vec3(0.0, 0.0, 1.0);
    v5.y = generateHeight(v5 + worldOffset);

    currentPosition.y = generateHeight(currentPosition + worldOffset);

    // Step 3. Calculate smooth normal using the neighbour vertices.
    vec3 norm0 = normalize(cross(v0 - v2, v0 - currentPosition));
    vec3 norm1 = normalize(cross(v1 - v0, v1 - currentPosition));
    vec3 norm2 = normalize(cross(v1 - currentPosition, v1 - v3));
    vec3 norm3 = normalize(cross(currentPosition - v2, currentPosition - v4));
    vec3 norm4 = normalize(cross(currentPosition - v4, currentPosition - v5));
    vec3 norm5 = normalize(cross(v3 - currentPosition, v3 - v5));

    vec3 normal = normalize(norm0 + norm1 + norm2 + norm3 + norm4 + norm5);

    // Step 4. Color the vertex.
    vec3 color = vertexColor(currentPosition.y) * (ambientLight() + sunLight(normal));

    // Step 5. Apply fog.
    //float normalizedDistance = min(distance(uCameraPosition, currentPosition) / uFogDistance, 1.0);
    //vColor = mix(color, uFog, pow(normalizedDistance, 3.0));
    vColor = color;

    // Step 6. Final transformation.
    gl_Position = uProjectionMatrix * uViewMatrix * vec4(currentPosition, 1.0);
}

float generateHeight(vec3 position)
{
    float horizontalDividend0 = uOctave0HorizontalWaveLength;
    float verticalDividend0 = uOctave0VerticalWaveLength;
    vec2 inp0 = vec2(position.x / horizontalDividend0, position.z / verticalDividend0);
    float h0 = snoise(inp0) * uOctave0Altitude;

    float horizontalDividend1 = uOctave1HorizontalWaveLength;
    float verticalDividend1 = uOctave1VerticalWaveLength;
    vec2 inp1 = vec2(position.x / horizontalDividend1, position.z / verticalDividend1);
    float h1 = snoise(inp1) * uOctave1Altitude;

    float horizontalDividend2 = uOctave2HorizontalWaveLength;
    float verticalDividend2 = uOctave2VerticalWaveLength;
    vec2 inp2 = vec2(position.x / horizontalDividend2, position.z / verticalDividend2);
    float h2 = snoise(inp2) * uOctave2Altitude;

    return h0 + h1 + h2;
}

vec3 vertexColor(float height)
{
    // Adjust the height (as it can be below zero).
    height = (height + uMaxTerrainAltitude) * 0.5;

    // Normalize the height.
    height = height / uMaxTerrainAltitude;

    // Interpolate vertex color.
    vec3 color = mix(uColor0, uColor1, smoothstep(0.0, 0.2, height));
    color = mix(color, uColor2, smoothstep(0.2, 0.7, height));
    color = mix(color, uColor3, smoothstep(0.7, 1.0, height));

    return color;
}

vec3 ambientLight()
{
    return uAmbientLightColor * uAmbientLightStrength;
}

vec3 sunLight(vec3 normal)
{
    float diffuse = max(dot(normal, uSunLightDirection), 0.0);
    return uSunLightColor * diffuse;
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
