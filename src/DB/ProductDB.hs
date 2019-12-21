{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module DB.ProductDB where
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.Types
import Database.PostgreSQL.Simple.ToField
import qualified Data.ByteString as BS
import qualified Data.Text.Lazy as TL
import Data.Time
import Model.Product
import Database.PostgreSQL.Simple.ToField

insertProductQuery = Query {fromQuery = BS.concat ["insert into product (brand_id,one_category_id,two_category_id,supplier_id,price,average_cost,",
                                          "publish_status,audit_status,weight,length,height,",
                                          "width,production_date,shelf_life,product_core,product_name," ,
                                          "bar_code,color_type,description,indate) " ,
                                           "values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) returning product_id"]}
updateProductQuery = Query {fromQuery = BS.concat ["update product set brand_id=?,one_category_id=?,two_category_id=?,supplier_id=?,price=?,average_cost=?,",
                                          "publish_status=?,audit_status=?,weight=?,length=?,height=?," ,
                                          "width=?,production_date=?,shelf_life=?,product_core=?,product_name=?," ,
                                          "bar_code=?,color_type=?,description=?,indate=?,modified_time=?" ,
                                          "where product_id=?"]}
selectAllProductQuery = "select * from product"
selectProductByIdQuery = "select * from product where product_id in ?"
deleteProductByIdQuery = "delete from product where product_id in ?"

insertProduct :: Connection -> Product -> IO Product
insertProduct conn item = do
    [Only cid] <- query conn insertProductQuery (toInsertRow item)
    return item { product_id = cid }

updateProduct :: Connection -> Product -> IO ()
updateProduct conn item = do
     now <- getCurrentTime
     execute conn updateProductQuery (toInsertRow item ++ [toField $ now, toField $ product_id item])
     return ()

selectAllProduct :: Connection -> IO [Product]
selectAllProduct conn = do
     query_ conn selectAllProductQuery :: IO [Product]

selectProductById :: Connection -> TL.Text -> IO [Product]
selectProductById conn id = do
     query conn  selectProductByIdQuery  (Only (In [id])) :: IO [Product]

deleteProductById :: Connection -> TL.Text -> IO ()
deleteProductById conn id = do
     execute conn deleteProductByIdQuery (Only (In [id]))
     return ()