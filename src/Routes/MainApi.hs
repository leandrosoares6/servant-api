{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module Routes.MainApi where
    
    import Routes.UserApi as UserApi
    import Routes.ContactApi as ContactApi
    import Servant
    import Data.Pool
    import Database.PostgreSQL.Simple

    type MainApi =
        UserApi :<|>
        ContactApi

    mainApi :: Proxy MainApi
    mainApi = Proxy

    server :: Pool Connection -> Server MainApi
    server conns =
        UserApi.server conns :<|>
        ContactApi.server conns