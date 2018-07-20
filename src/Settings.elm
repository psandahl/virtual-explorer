module Settings
    exposing
        ( farPlane
        , fov
        , maxCameraAltitude
        , maxTerrainAltitude
        , nearPlane
        , octave0MaxAltitude
        , octave0MaxWaveLength
        , octave1MaxAltitude
        , octave1MaxWaveLength
        , octave2MaxAltitude
        , octave2MaxWaveLength
        )

{-| Settings constants.
-}


{-| Field of view.
-}
fov : Float
fov =
    45


{-| Near plane distance.
-}
nearPlane : Float
nearPlane =
    0.1


{-| Far plane distance.
-}
farPlane : Float
farPlane =
    2500


{-| Max wave length for octave 0.
-}
octave0MaxWaveLength : Float
octave0MaxWaveLength =
    3000


{-| Max altitude for octave 0.
-}
octave0MaxAltitude : Float
octave0MaxAltitude =
    200


{-| Max wave length for octave 1.
-}
octave1MaxWaveLength : Float
octave1MaxWaveLength =
    1111


{-| Max altitude for octave 1.
-}
octave1MaxAltitude : Float
octave1MaxAltitude =
    100


{-| Max wave length for octave 2.
-}
octave2MaxWaveLength : Float
octave2MaxWaveLength =
    333


{-| Max altitude for octave 2.
-}
octave2MaxAltitude : Float
octave2MaxAltitude =
    50


{-| The maximum terrain altitude.
-}
maxTerrainAltitude : Float
maxTerrainAltitude =
    octave0MaxAltitude + octave1MaxAltitude + octave2MaxAltitude


{-| The maximum camera altitude.
-}
maxCameraAltitude : Float
maxCameraAltitude =
    maxTerrainAltitude + 50
