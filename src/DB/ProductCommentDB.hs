{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module DB.ProductCommentDB where
import Database.PostgreSQL.Simple
import Model.ProductComment
import qualified Data.Text.Lazy as TL

insertProductCommentQuery = "insert into product_comment (product_id,order_id,customer_id,audit_status,title,content) values (?,?,?,?,?,?) returning comment_id"
updateProductCommentQuery = "update product_comment set product_id=?,order_id=?,customer_id=?,audit_status=?,title=?,content=?, where comment_id=?"
selectAllProductCommentQuery = "select * from product_comment"
selectProductCommentByIdQuery = "select * from product_comment where comment_id in ?"
deleteProductCommentByIdQuery = "delete from product_comment where comment_id in ?"

insertProductComment :: Connection -> ProductComment -> IO ProductComment
insertProductComment conn item = do
    [Only cid] <- query conn insertProductCommentQuery item
    return item { comment_id = cid }

updateProductComment :: Connection -> ProductComment -> IO ()
updateProductComment conn item = do
     execute conn updateProductCommentQuery item
     return ()

selectAllProductComment :: Connection -> IO [ProductComment]
selectAllProductComment conn = do
     query_ conn selectAllProductCommentQuery :: IO [ProductComment]

selectProductCommentById :: Connection -> TL.Text -> IO [ProductComment]
selectProductCommentById conn id = do
     query conn  selectProductCommentByIdQuery  (Only (In [id])) :: IO [ProductComment]

deleteProductCommentById :: Connection -> TL.Text -> IO ()
deleteProductCommentById conn id = do
     execute conn deleteProductCommentByIdQuery (Only (In [id]))
     return ()