{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module DB.CustomerPointLogDB where
import Database.PostgreSQL.Simple
import Model.CustomerPointLog
import qualified Data.Text.Lazy as TL

insertCustomerPointLogQuery = "insert into customer_point_log (customer_id,source,refer_number,change_point) values (?,?,?,?) returning point_id"
updateCustomerPointLogQuery = "update customer_point_log set customer_id=?,source=?,refer_number=?,change_point=? where point_id=?"
selectAllCustomerPointLogQuery = "select * from customer_point_log"
selectCustomerPointLogByIdQuery = "select * from customer_point_log where point_id in ?"
deleteCustomerPointLogByIdQuery = "delete from customer_point_log where point_id in ?"

insertCustomerPointLog :: Connection -> CustomerPointLog -> IO CustomerPointLog
insertCustomerPointLog conn item = do
    [Only cid] <- query conn insertCustomerPointLogQuery item
    return item { point_id = cid }

updateCustomerPointLog :: Connection -> CustomerPointLog -> IO ()
updateCustomerPointLog conn item = do
     execute conn updateCustomerPointLogQuery item
     return ()

selectAllCustomerPointLog :: Connection -> IO [CustomerPointLog]
selectAllCustomerPointLog conn = do
     query_ conn selectAllCustomerPointLogQuery :: IO [CustomerPointLog]

selectCustomerPointLogById :: Connection -> TL.Text -> IO [CustomerPointLog]
selectCustomerPointLogById conn id = do
     query conn  selectCustomerPointLogByIdQuery  (Only (In [id])) :: IO [CustomerPointLog]

deleteCustomerPointLogById :: Connection -> TL.Text -> IO ()
deleteCustomerPointLogById conn id = do
     execute conn deleteCustomerPointLogByIdQuery (Only (In [id]))
     return ()