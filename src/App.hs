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

    run :: IO ()
    run = do
        runDB
        let port = 4000
            settings =
                setPort port $
                setBeforeMainLoop (hPutStrLn stderr ("Listening on port " ++ show port ++ "...")) $
                defaultSettings
        runSettings settings =<< mkApp
    
    mkApp :: IO Application
    mkApp = return $ serve userApi server