module Item where

    import Data.Aeson
    import GHC.Generics

    data Item
        = Item {
            itemId :: Integer,
            itemText :: String
        }
        deriving (Eq, Show, Generic)

    instance ToJSON Item
    instance FromJSON Item
