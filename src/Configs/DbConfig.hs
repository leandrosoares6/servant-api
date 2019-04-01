{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module Configs.DbConfig where

    import Database.PostgreSQL.Simple
    import GHC.Generics
    import qualified Data.Configurator as C
    import qualified Data.Configurator.Types as C
    import Data.Pool(Pool, createPool, withResource)

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

    mkDbConf :: C.Config -> IO (Maybe DbConf)
    mkDbConf conf = do
        user <- C.lookup conf "database.user" :: IO (Maybe String)
        password <- C.lookup conf "database.password" :: IO (Maybe String)
        name <- C.lookup conf "database.password" :: IO (Maybe String)
        return $ DbConf <$> name
                        <*> user
                        <*> password



    runDB ::IO ()
    runDB = do
        loadDbConf <- C.load [C.Required "application.conf"]
        dbConf <- mkDbConf loadDbConf

        case dbConf of
            Nothing -> putStrLn "Arquivo de configuracao nao encontrado. Terminando..."
            Just conf -> do
                pool <- createPool (newConn conf) close 1 64 10
                _ <- execute_ pool "CREATE TABLE IF NOT EXISTS users (id SERIAL, name varchar(45) NOT NULL, email varchar(45) NOT NULL)"
                close pool

    {-     runDB :: IO ()

    runDB = do
        conn <- connect defaultConnectInfo {
            connectUser = "test",
            connectPassword = "test",
            connectDatabase = "servant"
        }
        _ <- execute_ conn "CREATE TABLE IF NOT EXISTS users (id SERIAL, name varchar(45) NOT NULL, email varchar(45) NOT NULL);"
        close conn -}