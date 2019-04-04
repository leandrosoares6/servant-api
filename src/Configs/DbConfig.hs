{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

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

    runDB :: IO ()
    runDB = do
        {- conn <- connect defaultConnectInfo {
            connectUser = "test",
            connectPassword = "test",
            connectDatabase = "servant"
        } -}
        loadCfg <- C.load [C.Required "application.conf"]
        dbCfg <- makeDbConfig loadCfg
        
        case dbCfg of
            Nothing -> putStrLn "Database nao encontrado para as configuracoes especificadas!"
            Just conf -> do
                conn <- newConn conf
                _ <- execute_ conn "CREATE TABLE IF NOT EXISTS users (id SERIAL, name varchar(45) NOT NULL, email varchar(45) NOT NULL);"
                close conn
{- 
            -- Aceita argumentos
    fetch :: (FromRow r, ToRow q) => Pool Connection -> q -> Query -> IO [r]
    fetch pool args sql = withResource pool retrieve
      where retrieve conn = query conn sql args

    -- Sem argumentos - Somente SQL puro
    fetchSimple :: FromRow r => Pool Connection -> Query -> IO [r]
    fetchSimple pool sql = withResource pool retrieve
       where retrieve conn = query_ conn sql

    -- Atualizando database
    execSql :: ToRow q => Pool Connection -> q -> Query -> IO Int64
    execSql pool args sql = withResource pool ins
       where ins conn = execute conn sql args -}