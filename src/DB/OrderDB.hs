{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module DB.OrderDB where
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.Types
import qualified Data.ByteString as BS
import qualified Data.Text.Lazy as TL
import Model.Order

import Data.Time
import Database.PostgreSQL.Simple.ToField

insertOrderQuery = Query {fromQuery = BS.concat ["insert into order_master (customer_id,payment_method,order_money,district_money,shipping_money,",
                                                             "payment_money,shipping_time,pay_time,receive_time,order_status,",
                                                             "order_point,shipping_user,province,city,district," ,
                                                             "address,invoice_title,shipping_comp_name,shipping_sn,order_sn,",
                                                             "create_time) " ,
                                                             "values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) returning order_id"]}

updateOrderQuery = Query {fromQuery = BS.concat ["update order_master set customer_id=?,payment_method=?,order_money=?,district_money=?,shipping_money=?,",
                                                             "payment_money=?,shipping_time=?,pay_time=?,receive_time=?,order_status=?," ,
                                                             "order_point=?,shipping_user=?,province=?,city=?,district=?," ,
                                                             "address=?,invoice_title=?,shipping_comp_name=?,shipping_sn=?,order_sn=?," ,
                                                             "modified_time=? ",
                                                             "where order_id=?"]}

selectAllOrderQuery = "select * from order_master"
selectOrderByIdQuery = "select * from order_master where order_id in ?"
deleteOrderByIdQuery = "delete from order_master where order_id in ?"

insertOrder :: Connection -> Order -> IO Order
insertOrder conn item = do
    now <- getCurrentTime
    [Only cid] <- query conn insertOrderQuery (toInsertRow item ++ [toField $ now])
    return item { order_id = cid }

updateOrder :: Connection -> Order -> IO ()
updateOrder conn item = do
     now <- getCurrentTime
     execute conn updateOrderQuery (toInsertRow item ++ [toField $ now, toField $ order_id item])
     return ()

selectAllOrder :: Connection -> IO [Order]
selectAllOrder conn = do
     query_ conn selectAllOrderQuery :: IO [Order]

selectOrderById :: Connection -> TL.Text -> IO [Order]
selectOrderById conn id = do
     query conn  selectOrderByIdQuery  (Only (In [id])) :: IO [Order]

deleteOrderById :: Connection -> TL.Text -> IO ()
deleteOrderById conn id = do
     execute conn deleteOrderByIdQuery (Only (In [id]))
     return ()