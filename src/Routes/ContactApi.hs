{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module Routes.ContactApi where

    import Models.Contact
    import Servant
    import GHC.Int
    import Data.Pool
    import Database.PostgreSQL.Simple
    import Controllers.ContactController

    -- Exemplo de uso de fatoração na estruturação do endpoint
    type ContactApi = 
        "contacts" :> Get '[JSON] [Contact] :<|>
        "contacts" :> Capture "id" Int64 :>  Get '[JSON] Contact :<|>
        "contacts" :> ReqBody '[JSON] Contact :> Post '[JSON] Contact

    server :: Pool Connection -> Server ContactApi
    server conns =
        getUserContacts conns :<|>
        getUserContactById conns :<|>
        createUserContact conns