{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
module Http.WarehouseProductHttp where

import Web.Scotty
import Data.Aeson (ToJSON)
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.ToField
import GHC.Generics
import Control.Monad.IO.Class
import Model.WarehouseProduct
import Model.ResultData
import DB.WarehouseProductDB

import qualified Data.Text.Lazy as TL
import qualified Data.Aeson as A

warehouseProductHttp :: Connection -> ScottyM ()
warehouseProductHttp conn = do
  get "/warehouseProductList" $ do
    warehouseProductList <- liftIO (selectAllWarehouseProduct conn)
    json $ resultData $ A.toJSON warehouseProductList

  get "/warehouseProductById" $ do
    id <- param "id" :: ActionM TL.Text
    warehouseProducts <- liftIO (selectWarehouseProductById conn id)
    json $ resultData $ A.toJSON warehouseProducts

  get "/deleteWarehouseProductById" $ do
    id <- param "id" :: ActionM TL.Text
    liftIO (deleteWarehouseProductById conn id)
    json $ resultData "ok"

  post "/insertWarehouseProduct" $ do
    warehouseProduct <- jsonData :: ActionM WarehouseProduct
    liftIO $ print warehouseProduct
    liftIO (insertWarehouseProduct conn warehouseProduct)
    json $ resultData "ok"
    
  post "/updateWarehouseProduct" $ do
    warehouseProduct <- jsonData :: ActionM WarehouseProduct
    liftIO (updateWarehouseProduct conn warehouseProduct)
    json $ resultData "ok"
   
   
       
