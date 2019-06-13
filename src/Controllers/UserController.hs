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
    import Servant
    import Data.Pool
    import Control.Monad.IO.Class
    import Database.PostgreSQL.Simple
    import Database.PostgreSQL.ORM.Model
    import Database.PostgreSQL.ORM.Association
    import Data.Maybe
    import GHC.Int
    import Data.String
    import System.IO.Unsafe
    

    getUsers :: Pool Connection -> Handler [User]
    getUsers conns = do
        getUsrs <-    liftIO . withResource conns $ \conn ->
                    findAll conn
        return getUsrs

    
    getUserById :: Pool Connection -> Int64 -> Handler (Maybe User)
    getUserById conns dbkey = liftIO. withResource conns $ \conn -> do
        getUsr <-   liftIO $ findRow conn (DBRef dbkey)
        return getUsr
        {- if (isJust getUsr)
            then pure $ (fromJust getUsr){- throwError err404 -}
            --else throwError $ err404 { errBody = "User not found." }
             -}
        
    createUser :: Pool Connection -> User -> Handler User
    createUser conns usr = do
        _ <-    liftIO . withResource conns $ \conn ->
                    trySave conn usr
        return usr

    {- removeUserContactsQuery :: Int64 -> Query
    removeUserContactsQuery userid = fromString $ mconcat ["delete from contact where user_id=", show userid]

    removeUserContacts :: Connection -> Int64 -> IO Int64
    removeUserContacts c userid = do
        removed <-  execute_ c $ removeUserContactsQuery userid
        return removed -}

    
    removeUser :: Pool Connection -> Int64 -> Handler NoContent
    removeUser conns userid = do
        _ <- liftIO . withResource conns $ \conn ->
                    destroyByRef conn (DBRef userid :: DBRef User)
        -- r <- liftIO . withResource conns $ \conn -> unsafePerformIO $ removeUserContacts conn userid
        return NoContent

    getUserContacts :: Pool Connection -> Int64 ->Handler [Contact]
    getUserContacts conns userCtId = liftIO . withResource conns $ \conn -> do
        getUsr <- liftIO $ findRow conn (DBRef userCtId :: DBRef User)
        getUsrCts <- findAssoc user_contacts conn (fromJust getUsr)
        return getUsrCts