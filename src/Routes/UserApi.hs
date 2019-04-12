{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module Routes.UserApi where

    import Models.User
    import Servant

    type UserApi = 
        {- "users" :> Get '[JSON] [User] :<|>
        "users" :> Capture "id" Integer :> Get '[JSON] User -}
        "users" :> ReqBody '[JSON] User :> Post '[JSON] NoContent

    userApi :: Proxy UserApi
    userApi = Proxy
