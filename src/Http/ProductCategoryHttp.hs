{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
module Http.ProductCategoryHttp where

import Web.Scotty
import Data.Aeson (ToJSON)
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.ToField
import GHC.Generics
import Control.Monad.IO.Class
import Model.ProductCategory
import Model.ResultData
import DB.ProductCategoryDB

import qualified Data.Text.Lazy as TL
import qualified Data.Aeson as A

productCategoryHttp :: Connection -> ScottyM ()
productCategoryHttp conn = do
  get "/productCategoryList" $ do
    productCategoryList <- liftIO (selectAllProductCategory conn)
    json $ resultData $ A.toJSON productCategoryList

  get "/productCategoryById" $ do
    id <- param "id" :: ActionM TL.Text
    productCategorys <- liftIO (selectProductCategoryById conn id)
    json $ resultData $ A.toJSON productCategorys

  get "/deleteProductCategoryById" $ do
    id <- param "id" :: ActionM TL.Text
    liftIO (deleteProductCategoryById conn id)
    json $ resultData "ok"

  post "/insertProductCategory" $ do
    productCategory <- jsonData :: ActionM ProductCategory
    liftIO $ print productCategory
    liftIO (insertProductCategory conn productCategory)
    json $ resultData "ok"
    
  post "/updateProductCategory" $ do
    productCategory <- jsonData :: ActionM ProductCategory
    liftIO (updateProductCategory conn productCategory)
    json $ resultData "ok"
   
   
       
