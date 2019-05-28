{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveDataTypeable #-}


module Controllers.ContactController where

    import Models.User
    import Models.Contact

    import Servant
    import Data.Pool
    import Control.Monad.IO.Class
    import Database.PostgreSQL.Simple
    import Database.PostgreSQL.ORM.Model
    import Data.Maybe
    import GHC.Int

    getUserContacts :: Pool Connection -> Int64 -> Handler [Contact]
    getUserContacts conns usrDbRef = do
        getUsrCts <-    liftIO . withResource conns $ \conn ->
                    findAll conn
        return getUsrCts

    getUserContactById :: Pool Connection -> Int64 -> Int64 -> Handler Contact
    getUserContactById conns usrDbRef dbkey = liftIO. withResource conns $ \conn -> do
        getUsrCtById <-   liftIO $ findRow conn (DBRef dbkey)
        return (fromJust getUsrCtById)

        
    createUserContact :: Pool Connection -> Int64 -> (Contact -> Handler Contact)
    createUserContact conns usrDbRef usrCt = do
        _ <-    liftIO . withResource conns $ \conn ->
                    trySave conn usrCt
        return usrCt