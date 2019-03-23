{-# LANGUAGE LambdaCase #-}

module Controllers.Controller where

    import Models.Item
    import System.IO
    import Servant
    import Network.Wai
    import Network.Wai.Handler.Warp

    getItems :: Handler [Item]
    getItems = return [exampleItem]

    getItemById :: Integer -> Handler Item
    getItemById = \ case
        0 -> return exampleItem
        _ -> throwError err404

    exampleItem :: Item
    exampleItem = Item 0 "example item"