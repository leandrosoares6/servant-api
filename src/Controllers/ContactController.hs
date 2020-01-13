{-# LANGUAGE LambdaCase         #-}
{-# LANGUAGE OverloadedStrings  #-}
{-# LANGUAGE TypeOperators      #-}
{-# LANGUAGE DataKinds          #-}
{-# LANGUAGE DeriveDataTypeable #-}


module Controllers.ContactController where

    import Models.Contact
    import Servant
    import Data.Pool
    import Data.Maybe
    import Control.Monad.IO.Class
    import Database.PostgreSQL.Simple
    import Database.PostgreSQL.ORM.Model
    import GHC.Int

    getContacts :: Pool Connection -> Handler [Contact]
    getContacts conns = do
        getCts <-    liftIO . withResource conns $ \conn ->
                    findAll conn
        return getCts

    fetchContactDB :: Pool Connection -> Int64 -> IO (Maybe Contact)
    fetchContactDB conns dbkey = do
        liftIO (
            withResource conns $ \conn -> do
                getCt <-   liftIO $ findRow conn (DBRef dbkey)
                case getCt of
                    Just contact -> return contact
                    Nothing -> return Nothing
            )

    getContactById :: Pool Connection -> Int64 -> Handler Contact
    getContactById conns dbkey = do
        contact <- liftIO (fetchContactDB conns dbkey)
        if (isJust contact)
            then (return (fromJust contact))
            else throwError contactNotFound
        where contactNotFound = err404 {
            errBody = "Contact not found."
        }        
        
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