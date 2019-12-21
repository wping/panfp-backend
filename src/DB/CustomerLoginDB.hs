{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module DB.CustomerLoginDB where
import Database.PostgreSQL.Simple
import Model.CustomerLogin
import qualified Data.Text.Lazy as TL

insertCustomerLoginQuery = "insert into customer_login (user_status,login_name,password) values (?,?,?) returning customer_id"
updateCustomerLoginQuery = "update customer_login set user_status=?,login_name=?,password=? where customer_id=?"
selectAllCustomerLoginQuery = "select * from customer_login"
selectCustomerLoginByIdQuery = "select * from customer_login where cutomer_id in ?"
deleteCustomerLoginByIdQuery = "delete from customer_login where customer_id in ?"

insertCustomerLogin :: Connection -> CustomerLogin -> IO CustomerLogin
insertCustomerLogin conn item = do
    [Only cid] <- query conn insertCustomerLoginQuery item
    return item { customer_id = cid }

updateCustomerLogin :: Connection -> CustomerLogin -> IO ()
updateCustomerLogin conn item = do
     execute conn updateCustomerLoginQuery item
     return ()

selectAllCustomerLogin :: Connection -> IO [CustomerLogin]
selectAllCustomerLogin conn = do
     query_ conn selectAllCustomerLoginQuery :: IO [CustomerLogin]

selectCustomerLoginById :: Connection -> TL.Text -> IO [CustomerLogin]
selectCustomerLoginById conn id = do
     query conn  selectCustomerLoginByIdQuery  (Only (In [id])) :: IO [CustomerLogin]

deleteCustomerLoginById :: Connection -> TL.Text -> IO ()
deleteCustomerLoginById conn id = do
     execute conn deleteCustomerLoginByIdQuery (Only (In [id]))
     return ()