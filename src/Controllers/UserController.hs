{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE ScopedTypeVariables #-}



module Controllers.UserController where

    import Models.User
    import Servant
    import Data.Pool
    import Control.Monad.IO.Class
    import Database.PostgreSQL.Simple
    import Database.PostgreSQL.ORM.Model
    import Data.Maybe
    import GHC.Int

    getUsers :: Pool Connection -> Handler [User]
    getUsers conns = do
        getUsrs <-    liftIO . withResource conns $ \conn ->
                    findAll conn
        return getUsrs

    getUserById :: Pool Connection -> Int64 -> Handler (User)
    getUserById conns dbkey = liftIO. withResource conns $ \conn -> do
        getUsr <-   liftIO $ findRow conn (DBRef dbkey)
        return (fromJust getUsr)
        
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