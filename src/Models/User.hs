{-# LANGUAGE DeriveGeneric #-}

module Models.User where

    import Data.Aeson
    import GHC.Generics
    import Database.PostgreSQL.ORM.Model
    --import Data.Time (UTCTime)

    data User
        = User {
            id :: !DBKey,
            name :: String,
            email :: String
            -- createdAt :: UTCTime
        }
        deriving (Show, Generic)
    instance Model User
    
    instance ToJSON User
    instance FromJSON User
    
