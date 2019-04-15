{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveDataTypeable #-}


module Controllers.UserController where

    import Models.User

    import Servant
    import Data.Pool
    import Database.PostgreSQL.Simple
    import Control.Monad.IO.Class
    import Database.PostgreSQL.ORM.Model


    {- getUsers :: Handler [User]
    getUsers = return [exampleUser]

    getUserById :: Integer -> Handler User
    getUserById = \ case
        1 -> return exampleUser
        _ -> throwError err404 -}

    createUser :: Pool Connection -> User -> Handler User
    createUser conns usr = do
        _ <-    liftIO . withResource conns $ \conn ->
                    trySave conn usr
        return usr
    

    {- exampleUser :: User
    exampleUser = User (DBKey 1) "Leandro Soares" "leandro@example.com" -}