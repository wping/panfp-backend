{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module DB.CustomerDB where
import Database.PostgreSQL.Simple
import Model.Customer
import qualified Data.Text.Lazy as TL

import Database.PostgreSQL.Simple.ToField
import Data.Time

insertCustomerQuery = "insert into customer (phone,name,gender,point,birthday,rank,balance,register_time) values (?,?,?,?,?,?,?,?) returning customer_id"
updateCustomerQuery = "update customer set phone=?,name=?,gender=?,point=?,birthday=?,rank=?,balance=? where customer_id=?"
selectAllCustomerQuery = "select * from customer"
selectCustomerByIdQuery = "select * from customer where customer_id in ?"
deleteCustomerByIdQuery = "delete from customer where customer_id in ?"


insertCustomer :: Connection -> Customer -> IO Customer
insertCustomer conn item = do
     now <- getCurrentTime
     [Only cid] <- query conn insertCustomerQuery (toInsertRow item ++ [toField $ now])
     return item { customer_id = cid }

updateCustomer :: Connection -> Customer -> IO ()
updateCustomer conn item = do
     now <- getCurrentTime
     execute conn updateCustomerQuery (toInsertRow item ++ [toField $ customer_id item])
     return ()

selectAllCustomer :: Connection -> IO [Customer]
selectAllCustomer conn = do
     query_ conn selectAllCustomerQuery :: IO [Customer]

selectCustomerById :: Connection -> TL.Text -> IO [Customer]
selectCustomerById conn id = do
     query conn  selectCustomerByIdQuery  (Only (In [id])) :: IO [Customer]

deleteCustomerById :: Connection -> TL.Text -> IO ()
deleteCustomerById conn id = do
     execute conn deleteCustomerByIdQuery (Only (In [id]))
     return ()