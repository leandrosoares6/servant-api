{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module Routes.UserApi where

    import Models.User
    import Servant
    import GHC.Int

    type UserApi = 
        "users" :> Get '[JSON] [User] :<|>
        "users" :> Capture "id" Int64 :> Get '[JSON] User :<|>
        "users" :> ReqBody '[JSON] User :> Post '[JSON] User

    userApi :: Proxy UserApi
    userApi = Proxy
