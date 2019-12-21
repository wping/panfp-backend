{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
module Http.ProductPicInfoHttp where

import Web.Scotty
import Data.Aeson (ToJSON)
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.ToField
import GHC.Generics
import Control.Monad.IO.Class
import Model.ProductPicInfo
import Model.ResultData
import DB.ProductPicInfoDB

import qualified Data.Text.Lazy as TL
import qualified Data.Aeson as A

productPicInfoHttp :: Connection -> ScottyM ()
productPicInfoHttp conn = do
  get "/productPicInfoList" $ do
    productPicInfoList <- liftIO (selectAllProductPicInfo conn)
    json $ resultData $ A.toJSON productPicInfoList

  get "/productPicInfoById" $ do
    id <- param "id" :: ActionM TL.Text
    productPicInfos <- liftIO (selectProductPicInfoById conn id)
    json $ resultData $ A.toJSON productPicInfos
    
    
  get "/productPicByProductId" $ do
    id <- param "id" :: ActionM TL.Text
    productPicInfos <- liftIO (selectProductPicInfoByProductId conn id)
    json $ resultData $ A.toJSON productPicInfos
    
  get "/deleteProductPicInfoById" $ do
    id <- param "id" :: ActionM TL.Text
    liftIO (deleteProductPicInfoById conn id)
    json $ resultData "ok"

  post "/insertProductPicInfo" $ do
    productPicInfo <- jsonData :: ActionM ProductPicInfo
    liftIO $ print productPicInfo
    liftIO (insertProductPicInfo conn productPicInfo)
    json $ resultData "ok"
    
  post "/updateProductPicInfo" $ do
    productPicInfo <- jsonData :: ActionM ProductPicInfo
    liftIO (updateProductPicInfo conn productPicInfo)
    json $ resultData "ok"
    
   
   
       
