module Settings
    exposing
        ( fov
        , nearPlane
        , farPlane
        , octave0MaxWaveLength
        , octave0MaxAltitude
        , octave1MaxWaveLength
        , octave1MaxAltitude
        , octave2MaxWaveLength
        , octave2MaxAltitude
        , maxTerrainAltitude
        , maxCameraAltitude
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
    1


{-| Far plane distance.
-}
farPlane : Float
farPlane =
    1000


{-| Max wave length for octave 0.
-}
octave0MaxWaveLength : Int
octave0MaxWaveLength =
    2048


{-| Max altitude for octave 0.
-}
octave0MaxAltitude : Int
octave0MaxAltitude =
    100


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
    maxTerrainAltitude + 10
