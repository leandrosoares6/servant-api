{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE OverloadedStrings #-}

module Models.Contact where

    import Models.User
    import Data.Aeson
    import GHC.Generics
    import Database.PostgreSQL.ORM.Model

    data Contact
        = Contact {
            id :: DBKey,
            userId :: DBRef User,
            name :: String,
            number :: String
            -- createdAt :: UTCTime
        }
        deriving (Show, Generic)
    instance Model Contact where modelInfo = underscoreModelInfo "contact"
    
    instance ToJSON Contact
    instance FromJSON Contact