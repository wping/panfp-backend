{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
module Http.ShippingHttp where

import Web.Scotty
import Data.Aeson (ToJSON)
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.ToField
import GHC.Generics
import Control.Monad.IO.Class
import Model.Shipping
import Model.ResultData
import DB.ShippingDB

import qualified Data.Text.Lazy as TL
import qualified Data.Aeson as A

shippingHttp :: Connection -> ScottyM ()
shippingHttp conn = do
  get "/shippingList" $ do
    shippingList <- liftIO (selectAllShipping conn)
    json $ resultData $ A.toJSON shippingList

  get "/shippingById" $ do
    id <- param "id" :: ActionM TL.Text
    shippings <- liftIO (selectShippingById conn id)
    json $ resultData $ A.toJSON shippings

  get "/deleteShippingById" $ do
    id <- param "id" :: ActionM TL.Text
    liftIO (deleteShippingById conn id)
    json $ resultData "ok"

  post "/insertShipping" $ do
    shipping <- jsonData :: ActionM Shipping
    liftIO $ print shipping
    liftIO (insertShipping conn shipping)
    json $ resultData "ok"
    
  post "/updateShipping" $ do
    shipping <- jsonData :: ActionM Shipping
    liftIO (updateShipping conn shipping)
    json $ resultData "ok"
   
   
       
