{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
module Http.ProductHttp where

import Web.Scotty
import Data.Aeson (ToJSON)
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.ToField
import GHC.Generics
import Control.Monad.IO.Class
import Model.Product
import Model.ResultData
import DB.ProductDB

import qualified Data.Text.Lazy as TL
import qualified Data.Aeson as A

productHttp :: Connection -> ScottyM ()
productHttp conn = do
  get "/productList" $ do
    productList <- liftIO (selectAllProduct conn)
    json $ resultData $ A.toJSON productList

  get "/productById" $ do
    id <- param "id" :: ActionM TL.Text
    products <- liftIO (selectProductById conn id)
    json $ resultData $ A.toJSON products

  get "/deleteProductById" $ do
    id <- param "id" :: ActionM TL.Text
    liftIO (deleteProductById conn id)
    json $ resultData "ok"

  post "/insertProduct" $ do
    product <- jsonData :: ActionM Product
    liftIO $ print product
    liftIO (insertProduct conn product)
    json $ resultData "ok"
    
  post "/updateProduct" $ do
    product <- jsonData :: ActionM Product
    liftIO (updateProduct conn product)
    json $ resultData "ok"
   
   
       
