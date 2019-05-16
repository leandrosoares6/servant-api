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


    {- getUsers :: Handler [User]
    getUsers = return [exampleUser]

    getUserById :: Integer -> Handler User
    getUserById = \ case
        1 -> return exampleUser
        _ -> throwError err404 -}

    getUsers :: Pool Connection -> Handler [User]
    getUsers conns = do
        getUsrs <-    liftIO . withResource conns $ \conn ->
                    findAll conn
        return getUsrs

    getUserById :: Pool Connection -> Int64 -> Handler User
    getUserById conns dbkey = liftIO. withResource conns $ \conn -> do
        getUsr <-   liftIO $ findRow conn (DBRef dbkey)
        return (fromJust getUsr)

        
    createUser :: Pool Connection -> User -> Handler User
    createUser conns usr = do
        _ <-    liftIO . withResource conns $ \conn ->
                    trySave conn usr
        return usr
    

    {- exampleUser :: User
    exampleUser = User (DBKey 1) "Leandro Soares" "leandro@example.com" -}