{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
module Http.WarehouseHttp where

import Web.Scotty
import Data.Aeson (ToJSON)
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.ToField
import GHC.Generics
import Control.Monad.IO.Class
import Model.Warehouse
import Model.ResultData
import DB.WarehouseDB

import qualified Data.Text.Lazy as TL
import qualified Data.Aeson as A

warehouseHttp :: Connection -> ScottyM ()
warehouseHttp conn = do
  get "/warehouseList" $ do
    warehouseList <- liftIO (selectAllWarehouse conn)
    json $ resultData $ A.toJSON warehouseList

  get "/warehouseById" $ do
    id <- param "id" :: ActionM TL.Text
    warehouses <- liftIO (selectWarehouseById conn id)
    json $ resultData $ A.toJSON warehouses

  get "/deleteWarehouseById" $ do
    id <- param "id" :: ActionM TL.Text
    liftIO (deleteWarehouseById conn id)
    json $ resultData "ok"

  post "/insertWarehouse" $ do
    warehouse <- jsonData :: ActionM Warehouse
    liftIO $ print warehouse
    liftIO (insertWarehouse conn warehouse)
    json $ resultData "ok"
    
  post "/updateWarehouse" $ do
    warehouse <- jsonData :: ActionM Warehouse
    liftIO (updateWarehouse conn warehouse)
    json $ resultData "ok"
   
   
       
