
module Server where
    
    import Routes.UserApi
    import Routes.ContactApi
    import Controllers.UserController
    import Servant
    import Data.Pool
    import Database.PostgreSQL.Simple

    userServer :: Pool Connection -> Server UserApi
    userServer conns =
        getUsers conns :<|>
        getUserById conns :<|>
        createUser conns

    {- contactServer :: Pool Connection -> Server ContactApi
    contactServer conns =
        getUserContacts conns :<|>
        getUserContactsById conns :<|>
        createUserContact conns -}
        