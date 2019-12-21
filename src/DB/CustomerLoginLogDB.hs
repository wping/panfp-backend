{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module DB.CustomerLoginLogDB where
import Database.PostgreSQL.Simple
import Model.CustomerLoginLog
import qualified Data.Text.Lazy as TL

insertCustomerLoginLogQuery = "insert into customer_login_log (customer_id,login_type,login_time,login_ip) values (?,?,?,?,?) returning login_id"
updateCustomerLoginLogQuery = "update customer_login_log set customer_id=?,login_type=?,login_time=?,login_ip=? where login_id=?"
selectAllCustomerLoginLogQuery = "select * from customer_login_log"
selectCustomerLoginLogByIdQuery = "select * from customer_login_log where login_id in ?"
deleteCustomerLoginLogByIdQuery = "delete from customer_login_log where login_id in ?"

insertCustomerLoginLog :: Connection -> CustomerLoginLog -> IO CustomerLoginLog
insertCustomerLoginLog conn item = do
    [Only cid] <- query conn insertCustomerLoginLogQuery item
    return item { login_id = cid }

updateCustomerLoginLog :: Connection -> CustomerLoginLog -> IO ()
updateCustomerLoginLog conn item = do
     execute conn updateCustomerLoginLogQuery item
     return ()

selectAllCustomerLoginLog :: Connection -> IO [CustomerLoginLog]
selectAllCustomerLoginLog conn = do
     query_ conn selectAllCustomerLoginLogQuery :: IO [CustomerLoginLog]

selectCustomerLoginLogById :: Connection -> TL.Text -> IO [CustomerLoginLog]
selectCustomerLoginLogById conn id = do
     query conn  selectCustomerLoginLogByIdQuery  (Only (In [id])) :: IO [CustomerLoginLog]

deleteCustomerLoginLogById :: Connection -> TL.Text -> IO ()
deleteCustomerLoginLogById conn id = do
     execute conn deleteCustomerLoginLogByIdQuery (Only (In [id]))
     return ()