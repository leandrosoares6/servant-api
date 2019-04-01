{-# LANGUAGE LambdaCase #-}

module Controllers.UserController where

    import Configs.DbConfig
    import Models.User
    import Servant

    getUsers :: Handler [User]
    getUsers = return [exampleUser]

    getUserById :: Integer -> Handler User
    getUserById = \ case
        1 -> return exampleUser
        _ -> throwError err404

    createUser :: User -> Handler NoContent
    createUser usr = do
        _ <- execute conn
                "INSERT INTO users VALUES (?)"
                (usr)
        close conn

    exampleUser :: User
    exampleUser = User 1 "Leandro Soares" "leandro@example.com"