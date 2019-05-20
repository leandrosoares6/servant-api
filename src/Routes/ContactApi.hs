{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module Routes.ContactApi where

    import Models.Contact
    import Servant
    import GHC.Int

    -- Exemplo de uso de fatoração na estruturação do endpoint
    type ContactApi = 
        "users" :> Capture "id" Int64 :> "contacts" :> 
        (
            Get '[JSON] [Contact] :<|>
            Capture "id" Int64 :>  Get '[JSON] Contact :<|>
            ReqBody '[JSON] Contact :> Post '[JSON] Contact
        )

    contactApi :: Proxy ContactApi
    contactApi = Proxy
