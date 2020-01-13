{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric     #-}

module Configs.DbConfig where

    import Database.PostgreSQL.Simple
    import GHC.Generics
    import qualified Data.Configurator as C
    import qualified Data.Configurator.Types as C
    
    data DbConf
        = DbConf {
            user :: String,
            password :: String,
            database :: String
        }
        deriving (Eq, Show, Generic)

    newConn :: DbConf -> IO Connection
    newConn conf
        = connect defaultConnectInfo {
            connectUser = user conf,
            connectPassword = password conf,
            connectDatabase = database conf
        }

    makeDbConfig :: C.Config -> IO (Maybe DbConf)
    makeDbConfig conf = do
        usr <- C.lookup conf "database.user" :: IO (Maybe String)
        pwd <- C.lookup conf "database.password" :: IO (Maybe String)
        dtb <- C.lookup conf "database.name" :: IO (Maybe String)
        return $ DbConf <$> usr
                        <*> pwd
                        <*> dtb