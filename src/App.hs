{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module App where

-- Dependencias criadas pelo desenvolvedor
    import Configs.DbConfig
    import Routes.MainApi
    --import Server
    --import Models.User

-- Dependencias externas
    import System.IO
    import Network.Wai
    import Network.Wai.Handler.Warp
    import Servant
    import Database.PostgreSQL.Simple
    --import Database.PostgreSQL.ORM.Model
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
                --let usr = User NullKey "leandro" "leandro@example.com"
                conn <- newConn conf
                _ <- execute_ conn "CREATE TABLE IF NOT EXISTS \"user\"(id serial primary key, name varchar(45) NOT NULL, email varchar(45) NOT NULL);"
                _ <- execute_ conn "CREATE TABLE IF NOT EXISTS \"contact\"(id serial primary key, user_id integer NOT NULL, name varchar(45) NOT NULL, number varchar(15) NOT NULL);"
                --_ <- trySave conn usr
                pool <- createPool (newConn conf) close 1 64 10
                let port = 4000
                    settings =
                        setPort port $
                        setBeforeMainLoop (hPutStrLn stderr ("Listening on port " ++ show port ++ "...")) $
                        defaultSettings
                runSettings settings =<< mkApp pool
    
    mkApp :: Pool Connection -> IO Application
    mkApp conns = return $ (serve mainApi (server conns))