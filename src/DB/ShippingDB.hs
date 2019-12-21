{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module DB.ShippingDB where
import Database.PostgreSQL.Simple
import Model.Shipping
import qualified Data.Text.Lazy as TL
  
insertShippingQuery = "insert into shipping (ship_name,ship_contact,phone,price) values (?,?,?,?) returning ship_id"
updateShippingQuery = "update shipping set ship_name=?,ship_contact=?,phone=?,price=? where ship_id=?"
selectAllShippingQuery = "select * from shipping"
selectShippingByIdQuery = "select * from shipping where ship_id in ?"
deleteShippingByIdQuery = "delete from shipping where ship_id in ?"

insertShipping :: Connection -> Shipping -> IO Shipping
insertShipping conn item = do
    [Only cid] <- query conn insertShippingQuery item
    return item { ship_id = cid }

updateShipping :: Connection -> Shipping -> IO ()
updateShipping conn item = do
     execute conn updateShippingQuery item
     return ()

selectAllShipping :: Connection -> IO [Shipping]
selectAllShipping conn = do
     query_ conn selectAllShippingQuery :: IO [Shipping]

selectShippingById :: Connection -> TL.Text -> IO [Shipping]
selectShippingById conn id = do
     query conn  selectShippingByIdQuery  (Only (In [id])) :: IO [Shipping]

deleteShippingById :: Connection -> TL.Text -> IO ()
deleteShippingById conn id = do
     execute conn deleteShippingByIdQuery (Only (In [id]))
     return ()