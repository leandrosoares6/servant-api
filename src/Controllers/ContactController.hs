{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveDataTypeable #-}


module Controllers.ContactController where

    --import Models.User
    import Models.Contact
    import Models.Associations

    import Servant
    import Data.Pool
    import Control.Monad.IO.Class
    import Database.PostgreSQL.Simple
    import Database.PostgreSQL.ORM.Model
    import Database.PostgreSQL.ORM.Association
    import Database.PostgreSQL.ORM.DBSelect
    import Data.Maybe
    import Data.Char
    import GHC.Int

    getUserContacts :: Pool Connection -> Int64 ->Handler [Contact]
    getUserContacts conns userid = liftIO . withResource conns $ \conn -> do
        getUsr <- liftIO $ findRow conn (DBRef userid)
        getUsrCts <- findAssoc user_contacts conn (fromJust getUsr)
        return getUsrCts

    contactById :: Int64 -> Int64 -> DBSelect (Contact)
    contactById userid dbkey = 
        expressionDBSelect "* from contact where user_id=" ++ (show userid) ++ " and id=" ++ (show dbkey)

    getUserContactById :: Pool Connection -> Int64 -> Int64 -> Handler (Contact)
    getUserContactById conns userid dbkey = liftIO. withResource conns $ \conn -> do
        getUsrCtById <-   liftIO $ dbSelect conn $ contactById userid dbkey
        return (getUsrCtById!!0)

        
    createUserContact :: Pool Connection -> Int64 -> Contact -> Handler Contact
    createUserContact conns userid usrCt = do
        _ <-    liftIO . withResource conns $ \conn ->
                    trySave conn usrCt
        return usrCt