{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}


module Routes.UserApi where

    import Models.User
    import Models.Contact (Contact)
    import Servant
    import GHC.Int
    import Data.Pool
    import Database.PostgreSQL.Simple
    import Controllers.UserController

    type UserApi
        = "users" :> (
                        Get '[JSON] [User] :<|>
                        Capture "id" Int64 :> Get '[JSON] (Maybe User) :<|>
                        ReqBody '[JSON] User :> Post '[JSON] User :<|>
                        Capture "id" Int64 :> Delete '[JSON] NoContent :<|>
                        Capture "id" Int64 :> "contacts" :> Get '[JSON] [Contact]
                    )

    server :: Pool Connection -> Server UserApi
    server conns =
        getUsers conns :<|>
        getUserById conns :<|>
        createUser conns :<|>
        removeUser conns :<|>
        getUserContacts conns