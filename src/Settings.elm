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
octave0MaxWaveLength : Int
octave0MaxWaveLength =
    2048


{-| Max altitude for octave 0.
-}
octave0MaxAltitude : Int
octave0MaxAltitude =
    150


{-| Max wave length for octave 1.
-}
octave1MaxWaveLength : Int
octave1MaxWaveLength =
    256


{-| Max altitude for octave 1.
-}
octave1MaxAltitude : Int
octave1MaxAltitude =
    40


{-| Max wave length for octave 2.
-}
octave2MaxWaveLength : Int
octave2MaxWaveLength =
    64


{-| Max altitude for octave 2.
-}
octave2MaxAltitude : Int
octave2MaxAltitude =
    10


{-| The maximum terrain altitude.
-}
maxTerrainAltitude : Int
maxTerrainAltitude =
    octave0MaxAltitude + octave1MaxAltitude + octave2MaxAltitude


{-| The maximum camera altitude.
-}
maxCameraAltitude : Int
maxCameraAltitude =
    maxTerrainAltitude + 50
