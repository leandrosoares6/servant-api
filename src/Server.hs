module Server where
    
    import ItemApi

    server :: Server ItemApi
    server =
        getItems :<|>
        getItemById