{-# LANGUAGE DeriveGeneric, OverloadedStrings #-}

module Models.User where

    import Data.Aeson
    import GHC.Generics
    import Database.PostgreSQL.ORM.Model

    data User
        = User {
            id :: DBKey,
            name :: String,
            email :: String
        }
        deriving (Show, Generic)
    instance Model User where modelInfo = underscoreModelInfo "user"
    
    instance ToJSON User
    instance FromJSON User