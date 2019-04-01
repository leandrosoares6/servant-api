{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module Routes.UserApi where

    import Models.User
    import Servant

    type UserApi = 
        "users" :> Get '[JSON] [User] :<|>
        "users" :> Capture "id" Integer :> Get '[JSON] User

    userApi :: Proxy UserApi
    userApi = Proxy
