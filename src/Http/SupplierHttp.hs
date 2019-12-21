{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
module Http.SupplierHttp where

import Web.Scotty
import Data.Aeson (ToJSON)
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.ToField
import GHC.Generics
import Control.Monad.IO.Class
import Model.Supplier
import Model.ResultData
import DB.SupplierDB

import qualified Data.Text.Lazy as TL
import qualified Data.Aeson as A

supplierHttp :: Connection -> ScottyM ()
supplierHttp conn = do
  get "/supplierList" $ do
    supplierList <- liftIO (selectAllSupplier conn)
    json $ resultData $ A.toJSON supplierList

  get "/supplierById" $ do
    id <- param "id" :: ActionM TL.Text
    suppliers <- liftIO (selectSupplierById conn id)
    json $ resultData $ A.toJSON suppliers

  get "/deleteSupplierById" $ do
    id <- param "id" :: ActionM TL.Text
    liftIO (deleteSupplierById conn id)
    json $ resultData "ok"

  post "/insertSupplier" $ do
    supplier <- jsonData :: ActionM Supplier
    liftIO $ print supplier
    liftIO (insertSupplier conn supplier)
    json $ resultData "ok"
    
  post "/updateSupplier" $ do
    supplier <- jsonData :: ActionM Supplier
    liftIO (updateSupplier conn supplier)
    json $ resultData "ok"
   
   
       
