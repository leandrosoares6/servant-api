{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE ScopedTypeVariables #-}



module Controllers.UserController where

    import Models.User
    import Models.Contact (Contact)
    import Models.Associations
    import Servant.Server (Handler, ServantErr, errBody, err404)
    import Servant.API.ContentTypes
    import Data.Pool
    import Control.Monad.IO.Class
    import Database.PostgreSQL.Simple
    import Database.PostgreSQL.ORM.Model
    import Database.PostgreSQL.ORM.Association
    import Data.Maybe
    import GHC.Int
    import Control.Monad.Except

    {- custom404Err = err404 { errBody = "myfile.txt just isn't there, please leave this server alone." } -}


    getUsers :: Pool Connection -> Handler [User]
    getUsers conns = do
        getUsrs <-    liftIO . withResource conns $ \conn ->
                    findAll conn
        return getUsrs

    
    getUserById :: Pool Connection -> Int64 -> Handler (Maybe User)
    getUserById conns dbkey = liftIO. withResource conns $ \conn -> do
        getUsr <-   liftIO $ findRow conn (DBRef dbkey)
        if (isNothing getUsr)
            then return getUsr{- throwError err404 -}
            else return getUsr
        
    createUser :: Pool Connection -> User -> Handler User
    createUser conns usr = do
        _ <-    liftIO . withResource conns $ \conn ->
                    trySave conn usr
        return usr
    
    removeUser :: Pool Connection -> Int64 -> Handler NoContent
    removeUser conns userid = do
        _ <-    liftIO . withResource conns $ \conn ->
                    destroyByRef conn (DBRef userid :: DBRef User)
        return NoContent

    getUserContacts :: Pool Connection -> Int64 ->Handler [Contact]
    getUserContacts conns userCtId = liftIO . withResource conns $ \conn -> do
        getUsr <- liftIO $ findRow conn (DBRef userCtId :: DBRef User)
        getUsrCts <- findAssoc user_contacts conn (fromJust getUsr)
        return getUsrCts