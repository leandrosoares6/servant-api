{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module Routes.ContactApi where

    import Models.Contact
    import Servant
    import GHC.Int
    import Data.Pool
    import Database.PostgreSQL.Simple
    import Controllers.ContactController

    -- Exemplo de uso de fatoracao na estruturação do endpoint
    type ContactApi
        =   "users" :> Capture "id" Int64 :>
            "contacts" :> (
                            Get '[JSON] [Contact] :<|>
                            Capture "id" Int64 :>  Get '[JSON] Contact :<|>
                            ReqBody '[JSON] Contact :> Post '[JSON] Contact :<|>
                            Capture "id" Int64 :> Delete '[JSON] NoContent
                        )

    server :: Pool Connection -> Server ContactApi
    server conns userid =
        getUserContacts conns userid :<|>
        getUserContactById conns userid :<|>
        createUserContact conns :<|>
        removeUserContact conns