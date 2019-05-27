
module Exceptions.DatabaseException where

    import Servant.Exception
    
    data DatabaseError = QueryError
                        | ConnectionFailure
                        deriving (Show)

    instance Exception DatabaseError