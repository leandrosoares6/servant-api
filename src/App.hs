module App where

-- Dependencias criadas pelo desenvolvedor
    import Routes.UserApi
    import Server

-- Dependencias externas
    import System.IO
    import Network.Wai
    import Network.Wai.Handler.Warp
    import Servant

    run :: IO ()
    run = do
        let port = 3000
            settings =
                setPort port $
                setBeforeMainLoop (hPutStrLn stderr ("listening on port " ++ show port)) $
                defaultSettings
        runSettings settings =<< mkApp

    mkApp :: IO Application
    mkApp = return $ serve userApi server
