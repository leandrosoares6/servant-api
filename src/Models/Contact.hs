{-# LANGUAGE DeriveGeneric #-}

module Models.User where

    import Data.Aeson
    import GHC.Generics
    import Database.PostgreSQL.ORM.Model
    --import Data.Time (UTCTime)

    data Contact
        = User {
            id :: DBKey,
            name :: String,
            number :: String
            -- createdAt :: UTCTime
        }
        deriving (Show, Generic)
    instance Model Contact
    
    instance ToJSON Contact
    instance FromJSON Contact