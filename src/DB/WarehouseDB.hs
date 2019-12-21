{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module DB.WarehouseDB where
import Database.PostgreSQL.Simple
import Model.Warehouse
import qualified Data.Text.Lazy as TL

insertWarehouseQuery = "insert into warehouse (warehouse_status,warehouse_sn,warehouse_name,warehouse_phone,contact,city,district,address) values (?,?,?,?,?,?,?,?) returning w_id"
updateWarehouseQuery = "update warehouse set warehouse_status=?,warehouse_sn=?,warehouse_name=?, warehouse_phone=?,contact=?,city=?,district=?, address=? where w_id=?"
selectAllWarehouseQuery = "select * from warehouse"
selectWarehouseByIdQuery = "select * from warehouse where w_id in ?"
deleteWarehouseByIdQuery = "delete from warehouse where w_id in ?"

insertWarehouse :: Connection -> Warehouse -> IO Warehouse
insertWarehouse conn item = do
    [Only cid] <- query conn insertWarehouseQuery item
    return item { w_id = cid }

updateWarehouse :: Connection -> Warehouse -> IO ()
updateWarehouse conn item = do
     execute conn updateWarehouseQuery item
     return ()

selectAllWarehouse :: Connection -> IO [Warehouse]
selectAllWarehouse conn = do
     query_ conn selectAllWarehouseQuery :: IO [Warehouse]

selectWarehouseById :: Connection -> TL.Text -> IO [Warehouse]
selectWarehouseById conn id = do
     query conn  selectWarehouseByIdQuery  (Only (In [id])) :: IO [Warehouse]

deleteWarehouseById :: Connection -> TL.Text -> IO ()
deleteWarehouseById conn id = do
     execute conn deleteWarehouseByIdQuery (Only (In [id]))
     return ()