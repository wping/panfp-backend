{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module DB.SupplierDB where
import Database.PostgreSQL.Simple
import Model.Supplier
import qualified Data.Text.Lazy as TL

insertSupplierQuery = "insert into supplier (supplier_type,supplier_status,supplier_code,supplier_name,link_man,phone,bank_name,bank_account,address) values (?,?,?,?,?,?,?,?,?) returning supplier_id"
updateSupplierQuery = "update supplier set supplier_type=?,supplier_status=?,supplier_code=?,supplier_name=?,link_man=?,phone=?,bank_name=?,bank_account=?,address=? where supplier_id=?"
selectAllSupplierQuery = "select * from supplier"
selectSupplierByIdQuery = "select * from supplier where supplier_id in ?"
deleteSupplierByIdQuery = "delete from supplier where supplier_id in ?"

insertSupplier :: Connection -> Supplier -> IO Supplier
insertSupplier conn item = do
    [Only cid] <- query conn insertSupplierQuery item
    return item { supplier_id = cid }

updateSupplier :: Connection -> Supplier -> IO ()
updateSupplier conn item = do
     execute conn updateSupplierQuery item
     return ()

selectAllSupplier :: Connection -> IO [Supplier]
selectAllSupplier conn = do
     query_ conn selectAllSupplierQuery :: IO [Supplier]

selectSupplierById :: Connection -> TL.Text -> IO [Supplier]
selectSupplierById conn id = do
     query conn  selectSupplierByIdQuery  (Only (In [id])) :: IO [Supplier]

deleteSupplierById :: Connection -> TL.Text -> IO ()
deleteSupplierById conn id = do
     execute conn deleteSupplierByIdQuery (Only (In [id]))
     return ()