{-# LANGUAGE DeriveGeneric #-}

module Models.User where

    import Data.Aeson
    import GHC.Generics
    --import Data.Time (UTCTime)

    data User
        = User {
            id :: Integer,
            name :: String,
            email :: String
            -- createdAt :: UTCTime
        }
        deriving (Eq, Show, Generic)

    instance ToJSON User
    instance FromJSON User
    
