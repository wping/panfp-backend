{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module DB.CustomerBalanceLogDB where
import Database.PostgreSQL.Simple
import Model.CustomerBalanceLog
import qualified Data.Text.Lazy as TL

insertCustomerBalanceLogQuery = "insert into customer_balance_log (customer_id,source,amount,source_sn) values (?,?,?,?) returning balance_id"
updateCustomerBalanceLogQuery = "update customer_balance_log set customer_id=?,source=?,amount=?,source_sn=? where balance_id=?"
selectAllCustomerBalanceLogQuery = "select * from customer_balance_log"
selectCustomerBalanceLogByIdQuery = "select * from customer_balance_log where balance_id in ?"
deleteCustomerBalanceLogByIdQuery = "delete from customer_balance_log where balance_id in ?"

insertCustomerBalanceLog :: Connection -> CustomerBalanceLog -> IO CustomerBalanceLog
insertCustomerBalanceLog conn item = do
    [Only cid] <- query conn insertCustomerBalanceLogQuery item
    return item { balance_id = cid }

updateCustomerBalanceLog :: Connection -> CustomerBalanceLog -> IO ()
updateCustomerBalanceLog conn item = do
     execute conn updateCustomerBalanceLogQuery item
     return ()

selectAllCustomerBalanceLog :: Connection -> IO [CustomerBalanceLog]
selectAllCustomerBalanceLog conn = do
     query_ conn selectAllCustomerBalanceLogQuery :: IO [CustomerBalanceLog]

selectCustomerBalanceLogById :: Connection -> TL.Text -> IO [CustomerBalanceLog]
selectCustomerBalanceLogById conn id = do
     query conn  selectCustomerBalanceLogByIdQuery  (Only (In [id])) :: IO [CustomerBalanceLog]

deleteCustomerBalanceLogById :: Connection -> TL.Text -> IO ()
deleteCustomerBalanceLogById conn id = do
     execute conn deleteCustomerBalanceLogByIdQuery (Only (In [id]))
     return ()