{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module DB.CustomerLevelInfoDB where
import Database.PostgreSQL.Simple
import Model.CustomerLevelInfo
import qualified Data.Text.Lazy as TL

insertCustomerLevelInfoQuery = "insert into customer_level_info (min_point,max_point,level_name) values (?,?,?) returning customer_level_id"
updateCustomerLevelInfoQuery = "update customer_level_info set min_point=?,max_point=?,level_name=? where customer_level_id=?"
selectAllCustomerLevelInfoQuery = "select * from customer_level_info"
selectCustomerLevelInfoByIdQuery = "select * from customer_level_info where customer_level_id in ?"
deleteCustomerLevelInfoByIdQuery = "delete from customer_level_info where customer_level_id in ?"

insertCustomerLevelInfo :: Connection -> CustomerLevelInfo -> IO CustomerLevelInfo
insertCustomerLevelInfo conn item = do
    [Only cid] <- query conn insertCustomerLevelInfoQuery item
    return item { customer_level_id = cid }

updateCustomerLevelInfo :: Connection -> CustomerLevelInfo -> IO ()
updateCustomerLevelInfo conn item = do
     execute conn updateCustomerLevelInfoQuery item
     return ()

selectAllCustomerLevelInfo :: Connection -> IO [CustomerLevelInfo]
selectAllCustomerLevelInfo conn = do
     query_ conn selectAllCustomerLevelInfoQuery :: IO [CustomerLevelInfo]

selectCustomerLevelInfoById :: Connection -> TL.Text -> IO [CustomerLevelInfo]
selectCustomerLevelInfoById conn id = do
     query conn  selectCustomerLevelInfoByIdQuery  (Only (In [id])) :: IO [CustomerLevelInfo]

deleteCustomerLevelInfoById :: Connection -> TL.Text -> IO ()
deleteCustomerLevelInfoById conn id = do
     execute conn deleteCustomerLevelInfoByIdQuery (Only (In [id]))
     return ()