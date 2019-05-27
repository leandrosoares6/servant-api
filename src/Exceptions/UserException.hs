{-# LANGUAGE OverloadedStrings #-}

module Exceptions.UserException where

    import Servant.Server.Internal.ServantErr

    userNotFound :: ServantErr
    userNotFound = err404 {
                        errBody = "User not found."
                   }

    {- import Servant.Exception
    import Network.HTTP.Types.Status
    import Data.Aeson
    import Data.Typeable (typeOf)
    import qualified Data.Text as Text

    data UsersError = UserNotFound
                    | UserAlreadyExists
                    | BadUser
                    | InternalError
                    deriving (Show)

    instance Exception UsersError

    instance ToServantErr UsersError where
        status UserNotFound = status404
        status UserAlreadyExists = status409
        status BadUser = status400
        status InternalError = status500

        message InternalError = "Something bad happened internally"
        message e = Text.pack $ show e

    instance ToJSON UsersError where
        toJSON e = object [ "type" .= show (typeOf e)
                          , "message" .= message e
                          ] -}
