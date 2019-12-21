{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module DB.OrderCartDB where
import Database.PostgreSQL.Simple
import Model.OrderCart
import qualified Data.Text.Lazy as TL

insertOrderCartQuery = "insert into order_cart (customer_id,product_id,product_amount,price) values (?,?,?,?) returning cart_id"
updateOrderCartQuery = "update order_cart set customer_id=?,product_id=?,product_amount=?, price=? where cart_id=?"
selectAllOrderCartQuery = "select * from order_cart"
selectOrderCartByIdQuery = "select * from order_cart where cart_id in ?"
deleteOrderCartByIdQuery = "delete from order_cart where cart_id in ?"

insertOrderCart :: Connection -> OrderCart -> IO OrderCart
insertOrderCart conn item = do
    [Only cid] <- query conn insertOrderCartQuery item
    return item { cart_id = cid }

updateOrderCart :: Connection -> OrderCart -> IO ()
updateOrderCart conn item = do
     execute conn updateOrderCartQuery item
     return ()

selectAllOrderCart :: Connection -> IO [OrderCart]
selectAllOrderCart conn = do
     query_ conn selectAllOrderCartQuery :: IO [OrderCart]

selectOrderCartById :: Connection -> TL.Text -> IO [OrderCart]
selectOrderCartById conn id = do
     query conn  selectOrderCartByIdQuery  (Only (In [id])) :: IO [OrderCart]

deleteOrderCartById :: Connection -> TL.Text -> IO ()
deleteOrderCartById conn id = do
     execute conn deleteOrderCartByIdQuery (Only (In [id]))
     return ()