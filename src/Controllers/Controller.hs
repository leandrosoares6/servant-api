{-# LANGUAGE LambdaCase #-}

module Controllers.Controller where

    import Models.User
    import Servant

    getUsers :: Handler [User]
    getUsers = return [exampleUser]

    getUserById :: Integer -> Handler User
    getUserById = \ case
        0 -> return exampleUser
        _ -> throwError err404

    exampleUser :: User
    exampleUser = User 0 "Leandro Soares"