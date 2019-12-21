{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module DB.HotProductDB where
import Database.PostgreSQL.Simple
import Model.HotProduct
import qualified Data.Text.Lazy as TL

insertHotProductQuery = "insert into hotproduct (brand_id,status,order_id) values (?,?,?) returning hotproduct_id"
updateHotProductQuery = "update hotproduct set brand_id=?,status=?,order_id=? where hotproduct_id=?"
selectAllHotProductQuery = "select * from hotproduct"
selectHotProductByIdQuery = "select * from hotproduct where hotproduct_id in ?"
deleteHotProductByIdQuery = "delete from hotproduct where hotproduct_id in ?"

insertHotProduct :: Connection -> HotProduct -> IO HotProduct
insertHotProduct conn item = do
    [Only cid] <- query conn insertHotProductQuery item
    return item { hotproduct_id = cid }

updateHotProduct :: Connection -> HotProduct -> IO ()
updateHotProduct conn item = do
     execute conn updateHotProductQuery item
     return ()

selectAllHotProduct :: Connection -> IO [HotProduct]
selectAllHotProduct conn = do
     query_ conn selectAllHotProductQuery :: IO [HotProduct]

selectHotProductById :: Connection -> TL.Text -> IO [HotProduct]
selectHotProductById conn id = do
     query conn  selectHotProductByIdQuery  (Only (In [id])) :: IO [HotProduct]

deleteHotProductById :: Connection -> TL.Text -> IO ()
deleteHotProductById conn id = do
     execute conn deleteHotProductByIdQuery (Only (In [id]))
     return ()

