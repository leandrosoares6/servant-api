
module Server where
    
    import Routes.UserApi
    import Controllers.UserController
    import Servant
    import Data.Pool
    import Database.PostgreSQL.Simple

    server :: Pool Connection -> Server UserApi
    server conns =
        {- getUsers :<|>
        getUserById  -}
        createUser conns