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
    import Database.PostgreSQL.ORM


    {- getUsers :: Handler [User]
    getUsers = return [exampleUser]

    getUserById :: Integer -> Handler User
    getUserById = \ case
        1 -> return exampleUser
        _ -> throwError err404 -}

    user :: User
    user = User (DBKey 1) "leandro" "leandro@example.com"

    createUser :: Pool Connection -> User -> Handler NoContent
    createUser conns usr = do
        _ <-    liftIO . withResource conns $ \conn ->
                    save conn usr
        return NoContent
    

    {- exampleUser :: User
    exampleUser = User (DBKey 1) "Leandro Soares" "leandro@example.com" -}