{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveDataTypeable #-}


module Controllers.ContactController where

    import Models.Contact

    import Servant
    import Data.Pool
    import Control.Monad.IO.Class
    import Database.PostgreSQL.Simple
    import Database.PostgreSQL.ORM.Model
    import Data.Maybe

    import GHC.Int

    getContacts :: Pool Connection -> Handler [Contact]
    getContacts conns = do
        getCts <-    liftIO . withResource conns $ \conn ->
                    findAll conn
        return getCts

    getContactById :: Pool Connection -> Int64 -> Handler (Contact)
    getContactById conns dbkey = liftIO. withResource conns $ \conn -> do
        getCt <-   liftIO $ findRow conn (DBRef dbkey)
        return (fromJust getCt)
        
    createContact :: Pool Connection -> Contact -> Handler Contact
    createContact conns usrCt = do
        _ <-    liftIO . withResource conns $ \conn ->
                    trySave conn usrCt
        return usrCt

    removeContact :: Pool Connection -> Int64 -> Handler NoContent
    removeContact conns contactid = do
        _ <-    liftIO . withResource conns $ \conn ->
                    destroyByRef conn (DBRef contactid :: DBRef Contact)
        return NoContent