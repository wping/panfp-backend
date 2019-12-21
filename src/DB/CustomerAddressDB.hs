{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module DB.CustomerAddressDB where
import Database.PostgreSQL.Simple
import Model.CustomerAddress

import qualified Data.Text.Lazy as TL

insertCustomerAddressQuery = "insert into customer_address (customer_id,zip,is_default,province,city,district,address) values (?,?,?,?,?,?,?) returning customer_addr_id"
updateCustomerAddressQuery = "update customer_address set customer_id=?,zip=?,is_default=?,province=?,city=?,district=?,address=? where customer_addr_id=?"
selectAllCustomerAddressQuery = "select * from customer_address"
selectCustomerAddressByIdQuery = "select * from customer_address where customer_addr_id in ?"
deleteCustomerAddressByIdQuery = "delete from customer_address where customer_addr_id in ?"


insertCustomerAddress :: Connection -> CustomerAddress -> IO CustomerAddress
insertCustomerAddress conn item = do
    [Only customer_addr_id] <- query conn updateCustomerAddressQuery item
    return item { customer_addr_id = customer_addr_id }

updateCustomerAddress :: Connection -> CustomerAddress -> IO ()
updateCustomerAddress conn item = do
     execute conn updateCustomerAddressQuery item
     return ()

selectAllCustomerAddress :: Connection -> IO [CustomerAddress]
selectAllCustomerAddress conn = do
     query_ conn selectAllCustomerAddressQuery :: IO [CustomerAddress]

selectCustomerAddressById :: Connection -> TL.Text -> IO [CustomerAddress]
selectCustomerAddressById conn id = do
     query conn selectCustomerAddressByIdQuery  (Only (In [id])) :: IO [CustomerAddress]

deleteCustomerAddressById :: Connection -> TL.Text -> IO ()
deleteCustomerAddressById conn id = do
     execute conn deleteCustomerAddressByIdQuery (Only (In [id]))
     return ()


