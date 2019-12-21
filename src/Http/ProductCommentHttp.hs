{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
module Http.ProductCommentHttp where

import Web.Scotty
import Data.Aeson (ToJSON)
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.ToField
import GHC.Generics
import Control.Monad.IO.Class
import Model.ProductComment
import Model.ResultData
import DB.ProductCommentDB

import qualified Data.Text.Lazy as TL
import qualified Data.Aeson as A

productCommentHttp :: Connection -> ScottyM ()
productCommentHttp conn = do
  get "/productCommentList" $ do
    productCommentList <- liftIO (selectAllProductComment conn)
    json $ resultData $ A.toJSON productCommentList

  get "/productCommentById" $ do
    id <- param "id" :: ActionM TL.Text
    productComments <- liftIO (selectProductCommentById conn id)
    json $ resultData $ A.toJSON productComments

  get "/deleteProductCommentById" $ do
    id <- param "id" :: ActionM TL.Text
    liftIO (deleteProductCommentById conn id)
    json $ resultData "ok"

  post "/insertProductComment" $ do
    productComment <- jsonData :: ActionM ProductComment
    liftIO $ print productComment
    liftIO (insertProductComment conn productComment)
    json $ resultData "ok"
    
  post "/updateProductComment" $ do
    productComment <- jsonData :: ActionM ProductComment
    liftIO (updateProductComment conn productComment)
    json $ resultData "ok"
   
   
       
