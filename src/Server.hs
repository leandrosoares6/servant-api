module Server where
    
    import Routes.ItemApi
    import Controllers.Controller
    import Servant

    server :: Server ItemApi
    server =
        getItems :<|>
        getItemById