{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module DB.ProductPicInfoDB where
import Database.PostgreSQL.Simple
import Model.ProductPicInfo
import qualified Data.Text.Lazy as TL

insertProductPicInfoQuery = "insert into product_pic_info (product_id,pic_status,pic_desc,pic_url,is_master) values (?,?,?,?,?) returning product_pic_id"
updateProductPicInfoQuery = "update product_pic_info set product_id=?,pic_status=?,pic_desc=?, pic_url=?,is_master=? where product_pic_id=?"
selectAllProductPicInfoQuery = "select * from product_pic_info"
selectProductPicInfoByIdQuery = "select * from product_pic_info where product_pic_id in ?"
deleteProductPicInfoByIdQuery = "delete from product_pic_info where product_pic_id in ?"

selectProductPicInfoByProductIdQuery = "select * from product_pic_info where product_id in ?"

insertProductPicInfo :: Connection -> ProductPicInfo -> IO ProductPicInfo
insertProductPicInfo conn item = do
    [Only cid] <- query conn insertProductPicInfoQuery item
    return item { product_pic_id = cid }

updateProductPicInfo :: Connection -> ProductPicInfo -> IO ()
updateProductPicInfo conn item = do
     execute conn updateProductPicInfoQuery item
     return ()

selectAllProductPicInfo :: Connection -> IO [ProductPicInfo]
selectAllProductPicInfo conn = do
     query_ conn selectAllProductPicInfoQuery :: IO [ProductPicInfo]

selectProductPicInfoById :: Connection -> TL.Text -> IO [ProductPicInfo]
selectProductPicInfoById conn id = do
     query conn  selectProductPicInfoByIdQuery  (Only (In [id])) :: IO [ProductPicInfo]
     
selectProductPicInfoByProductId :: Connection -> TL.Text -> IO [ProductPicInfo]
selectProductPicInfoByProductId conn id = do
     query conn  selectProductPicInfoByIdQuery  (Only (In [id])) :: IO [ProductPicInfo]

deleteProductPicInfoById :: Connection -> TL.Text -> IO ()
deleteProductPicInfoById conn id = do
     execute conn deleteProductPicInfoByIdQuery (Only (In [id]))
     return ()