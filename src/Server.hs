module Server where
    
    import Routes.UserApi
    import Controllers.UserController
    import Servant

    server :: Server UserApi
    server =
        getUsers :<|>
        getUserById