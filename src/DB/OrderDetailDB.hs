{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module DB.OrderDetailDB where
import Database.PostgreSQL.Simple
import Model.OrderDetail
import qualified Data.Text.Lazy as TL

import Database.PostgreSQL.Simple.ToField

insertOrderDetailQuery = "insert into order_detail (order_id,product_id,product_cnt,product_price,average_cost,weight,fee_money,w_id,product_name) values (?,?,?,?,?,?,?,?,?) returning order_detail_id"
updateOrderDetailQuery = "update order_detail set order_id=?,product_id=?,product_cnt=?,product_price=?,average_cost=?,weight=?,fee_money=?,w_id=?,product_name=? where order_detail_id=?"
selectAllOrderDetailQuery = "select * from order_detail"
selectOrderDetailByIdQuery = "select * from order_detail where order_detail_id in ?"
selectOrderDetailByOrderIdQuery = "select * from order_detail where order_id in ?"
deleteOrderDetailByIdQuery = "delete from order_detail where order_detail_id in ?"

insertOrderDetail :: Connection -> OrderDetail -> IO OrderDetail
insertOrderDetail conn item = do
    [Only cid] <- query conn insertOrderDetailQuery $ toInsertRow item
    return item { order_detail_id = cid }

updateOrderDetail :: Connection -> OrderDetail -> IO ()
updateOrderDetail conn item = do
     execute conn updateOrderDetailQuery $ toInsertRow item ++ [toField $ order_detail_id item]
     return ()

selectAllOrderDetail :: Connection -> IO [OrderDetail]
selectAllOrderDetail conn = do
     query_ conn selectAllOrderDetailQuery :: IO [OrderDetail]

selectOrderDetailById :: Connection -> TL.Text -> IO [OrderDetail]
selectOrderDetailById conn id = do
     query conn  selectOrderDetailByIdQuery  (Only (In [id])) :: IO [OrderDetail]

selectOrderDetailByOrderId :: Connection -> TL.Text -> IO [OrderDetail]
selectOrderDetailByOrderId conn id = do
     query conn  selectOrderDetailByOrderIdQuery  (Only (In [id])) :: IO [OrderDetail]

deleteOrderDetailById :: Connection -> TL.Text -> IO ()
deleteOrderDetailById conn id = do
     execute conn deleteOrderDetailByIdQuery (Only (In [id]))
     return ()