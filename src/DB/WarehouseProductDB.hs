{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module DB.WarehouseProductDB where
import Database.PostgreSQL.Simple
import Model.WarehouseProduct
import qualified Data.Text.Lazy as TL

insertWarehouseProductQuery = "insert into warehouse_product (product_id,w_id,current_cnt,lock_cnt,in_transit_cnt,average_cost) values (?,?,?,?,?,?) returning wp_id"
updateWarehouseProductQuery = "update warehouse_product set product_id=?,w_id=?,current_cnt=?,lock_cnt=?,in_transit_cnt=?,average_cost=? where wp_id=?"
selectAllWarehouseProductQuery = "select * from warehouse_product"
selectWarehouseProductByIdQuery = "select * from warehouse_product where wp_id in ?"
deleteWarehouseProductByIdQuery = "delete from warehouse_product where wp_id in ?"

insertWarehouseProduct :: Connection -> WarehouseProduct -> IO WarehouseProduct
insertWarehouseProduct conn item = do
    [Only cid] <- query conn insertWarehouseProductQuery item
    return item { wp_id = cid }

updateWarehouseProduct :: Connection -> WarehouseProduct -> IO ()
updateWarehouseProduct conn item = do
     execute conn updateWarehouseProductQuery item
     return ()

selectAllWarehouseProduct :: Connection -> IO [WarehouseProduct]
selectAllWarehouseProduct conn = do
     query_ conn selectAllWarehouseProductQuery :: IO [WarehouseProduct]

selectWarehouseProductById :: Connection -> TL.Text -> IO [WarehouseProduct]
selectWarehouseProductById conn id = do
     query conn  selectWarehouseProductByIdQuery  (Only (In [id])) :: IO [WarehouseProduct]

deleteWarehouseProductById :: Connection -> TL.Text -> IO ()
deleteWarehouseProductById conn id = do
     execute conn deleteWarehouseProductByIdQuery (Only (In [id]))
     return ()