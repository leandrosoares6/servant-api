{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module App where

-- Dependencias criadas pelo desenvolvedor
    import Configs.DbConfig
    import Routes.UserApi
    import Server

-- Dependencias externas
    import System.IO
    import Network.Wai
    import Network.Wai.Handler.Warp
    import Servant
    import Database.PostgreSQL.Simple
    import Data.Pool
    import qualified Data.Configurator as C

    run :: IO ()
    run = do
        loadCfg <- C.load [C.Required "database.conf"]
        dbCfg <- makeDbConfig loadCfg
        
        case dbCfg of
            Nothing -> do
                putStrLn "Database nao encontrado para as configuracoes especificadas!"

            Just conf -> do
                {- conn <- newConn conf
                _ <- execute_ conn "CREATE TABLE IF NOT EXISTS users (id SERIAL PRIMARY KEY, name varchar(45) NOT NULL, email varchar(45) NOT NULL);" -}
                pool <- createPool (newConn conf) close 1 64 10
                let port = 4000
                    settings =
                        setPort port $
                        setBeforeMainLoop (hPutStrLn stderr ("Listening on port " ++ show port ++ "...")) $
                        defaultSettings
                runSettings settings =<< mkApp pool
    
    mkApp :: Pool Connection -> IO Application
    mkApp conns = return $ (serve userApi $ server conns)