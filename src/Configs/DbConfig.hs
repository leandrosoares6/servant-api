{-# LANGUAGE OverloadedStrings #-}

module Configs.DbConfig where

    import Database.PostgreSQL.Simple

    runDB :: IO ()

    runDB = do
        conn <- connect defaultConnectInfo {
            connectUser = "test",
            connectPassword = "test",
            connectDatabase = "servant"
        }
        _ <- execute_ conn "CREATE TABLE IF NOT EXISTS users (id SERIAL, name varchar(45) NOT NULL, email varchar(45) NOT NULL);"
        close conn