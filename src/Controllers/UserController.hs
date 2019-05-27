{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveDataTypeable #-}


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

    userNotFound :: Handler ()
    userNotFound = throwError err404 {
        errBody = "User not found!"
    }
    getUserById :: Pool Connection -> Int64 -> Handler (User)
    getUserById conns dbkey = liftIO. withResource conns $ \conn -> do
        getUsr <-   liftIO $ findRow conn (DBRef dbkey)
        return (fromJust getUsr)
        {- if (isJust getUsr)
            then return (fromJust getUsr)
            else userNotFound -}

        
    createUser :: Pool Connection -> User -> Handler User
    createUser conns usr = do
        _ <-    liftIO . withResource conns $ \conn ->
                    trySave conn usr
        return usr