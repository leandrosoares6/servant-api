{-# LANGUAGE LambdaCase           #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TypeOperators        #-}
{-# LANGUAGE DataKinds            #-}
{-# LANGUAGE DeriveDataTypeable   #-}
{-# LANGUAGE ScopedTypeVariables  #-}


module Controllers.UserController where

    import Models.User
    import Models.Contact (Contact)
    import Models.Associations
    import Servant
    import Data.Pool
    import Control.Monad.IO.Class
    import Database.PostgreSQL.Simple
    import Database.PostgreSQL.ORM.Model
    import Database.PostgreSQL.ORM.Association
    import Data.Maybe
    import GHC.Int

    getUsers :: Pool Connection -> Handler [User]
    getUsers conns = do
        getUsrs <-    liftIO . withResource conns $ \conn ->
                    findAll conn
        return getUsrs
    
    fetchUserDB :: Pool Connection -> Int64 -> IO (Maybe User)
    fetchUserDB conns dbkey = do
        liftIO (
            withResource conns $ \conn -> do
                getUsr <-   liftIO $ findRow conn (DBRef dbkey)
                case getUsr of
                    Just user -> return user
                    Nothing -> return Nothing
            )

    getUserById :: Pool Connection -> Int64 -> Handler User
    getUserById conns dbkey = do
        user <- liftIO (fetchUserDB conns dbkey)
        if (isJust user)
            then (return (fromJust user))
            else throwError userNotFound
        where userNotFound = err404 {
            errBody = "User not found."
        }
        
    createUser :: Pool Connection -> User -> Handler User
    createUser conns usr = do
        _ <-    liftIO . withResource conns $ \conn ->
                    trySave conn usr
        return usr

    removeUser :: Pool Connection -> Int64 -> Handler NoContent
    removeUser conns userid = do
        _ <- liftIO . withResource conns $ \conn ->
                    destroyByRef conn (DBRef userid :: DBRef User)
        return NoContent

    getUserContacts :: Pool Connection -> Int64 -> Handler [Contact]
    getUserContacts conns userCtId = liftIO . withResource conns $ \conn -> do
        getUsr <- liftIO $ findRow conn (DBRef userCtId :: DBRef User)
        getUsrCts <- findAssoc user_contacts conn (fromJust getUsr)
        return getUsrCts