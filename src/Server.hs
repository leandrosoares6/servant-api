module Server where
    
    import Routes.UserApi
    import Controllers.Controller
    import Servant

    server :: Server UserApi
    server =
        getUsers :<|>
        getUserById