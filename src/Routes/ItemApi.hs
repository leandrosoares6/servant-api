module Routes.ItemApi where

    import Item
    import Servant

    type ItemApi = 
        "item" :> Get '[JSON] [Item] :<|>
        "item" :> Capture "itemId" Integer :> Get '[JSON] Item

    itemApi :: Proxy ItemApi
    itemApi = Proxy
