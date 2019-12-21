{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module DB.ProductCategoryDB where
import Database.PostgreSQL.Simple
import Model.ProductCategory
import qualified Data.Text.Lazy as TL

insertProductCategoryQuery = "insert into product_category (parent_id,category_level,category_status,category_name,category_code) values (?,?,?) returning category_id"
updateProductCategoryQuery = "update product_category set parent_id=?,category_level=?,category_status=?,category_name=?,category_code=? where category_id=?"
selectAllProductCategoryQuery = "select * from product_category"
selectProductCategoryByIdQuery = "select * from product_category where category_id in ?"
deleteProductCategoryByIdQuery = "delete from product_category where category_id in ?"

insertProductCategory :: Connection -> ProductCategory -> IO ProductCategory
insertProductCategory conn item = do
    [Only cid] <- query conn insertProductCategoryQuery item
    return item { category_id = cid }

updateProductCategory :: Connection -> ProductCategory -> IO ()
updateProductCategory conn item = do
     execute conn updateProductCategoryQuery item
     return ()

selectAllProductCategory :: Connection -> IO [ProductCategory]
selectAllProductCategory conn = do
     query_ conn selectAllProductCategoryQuery :: IO [ProductCategory]

selectProductCategoryById :: Connection -> TL.Text -> IO [ProductCategory]
selectProductCategoryById conn id = do
     query conn  selectProductCategoryByIdQuery  (Only (In [id])) :: IO [ProductCategory]

deleteProductCategoryById :: Connection -> TL.Text -> IO ()
deleteProductCategoryById conn id = do
     execute conn deleteProductCategoryByIdQuery (Only (In [id]))
     return ()