{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module Routes.UserApi where

    import Models.User
    import Servant

    type UserApi = 
        "user" :> Get '[JSON] [User] :<|>
        "user" :> Capture "userId" Integer :> Get '[JSON] User

    userApi :: Proxy UserApi
    userApi = Proxy
