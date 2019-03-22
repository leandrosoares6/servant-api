module Server where
    
    import ItemApi
    
    import Network.Wai
    import Network.Wai.Handler.Warp

    server :: Server ItemApi
    server =
        getItems :<|>
        getItemById