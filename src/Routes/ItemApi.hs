{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module Routes.ItemApi where

    import Models.Item
    import Servant

    type ItemApi = 
        "item" :> Get '[JSON] [Item] :<|>
        "item" :> Capture "itemId" Integer :> Get '[JSON] Item

    itemApi :: Proxy ItemApi
    itemApi = Proxy
