{-# LANGUAGE DeriveGeneric #-}

module Models.User where

    import Data.Aeson
    import GHC.Generics

    data User
        = User {
            userId :: Integer,
            userName :: String
        }
        deriving (Eq, Show, Generic)

    instance ToJSON User
    instance FromJSON User
