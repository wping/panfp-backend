{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
module Http.BrandHttp where

import Web.Scotty
import Data.Aeson (ToJSON)
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.ToField
import GHC.Generics
import Control.Monad.IO.Class
import Model.Brand
import Model.ResultData
import DB.BrandDB

import qualified Data.Text.Lazy as TL
import qualified Data.Aeson as A

brandHttp :: Connection -> ScottyM ()
brandHttp conn = do
  get "/brandList" $ do
    brandList <- liftIO (selectAllBrand conn)
    json $ resultData $ A.toJSON brandList

  get "/brandById" $ do
    id <- param "id" :: ActionM TL.Text
    brands <- liftIO (selectBrandById conn id)
    json $ resultData $ A.toJSON brands

  get "/deleteBrandById" $ do
    id <- param "id" :: ActionM TL.Text
    liftIO (deleteBrandById conn id)
    json $ resultData "ok"

  post "/insertBrand" $ do
    brand <- jsonData :: ActionM Brand
    liftIO $ print brand
    liftIO (insertBrand conn brand)
    json $ resultData "ok"
    
  post "/updateBrand" $ do
    brand <- jsonData :: ActionM Brand
    liftIO (updateBrand conn brand)
    json $ resultData "ok"
   
   
       
