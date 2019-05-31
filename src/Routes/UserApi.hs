{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module Routes.UserApi where

    import Models.User
    import Servant
    import GHC.Int
    import Data.Pool
    import Database.PostgreSQL.Simple
    import Controllers.UserController
    --import Exceptions.UserException
    {- import Servant.Exception (Throws) -}


    type UserApi
        = "users" :> (
                        Get '[JSON] [User] :<|>
                        Capture "id" Int64 :> Get '[JSON] User :<|>
                        ReqBody '[JSON] User :> Post '[JSON] User
                    )

    server :: Pool Connection -> Server UserApi
    server conns =
        getUsers conns :<|>
        getUserById conns :<|>
        createUser conns