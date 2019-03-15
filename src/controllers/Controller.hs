import Item

getItems :: Handler [Item]

getItemById :: Integer -> Handler Item
getItemById = \ case
    0 -> return exampleItem
    _ -> throwError err404

exampleItem :: Item
exampleItem = Item 0 "example item"