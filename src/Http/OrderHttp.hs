{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
module Http.OrderHttp where

import Web.Scotty
import Data.Aeson (ToJSON)
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.ToField
import GHC.Generics
import Control.Monad.IO.Class
import Model.Order
import Model.ResultData
import DB.OrderDB

import qualified Data.Text.Lazy as TL
import qualified Data.Aeson as A

orderHttp :: Connection -> ScottyM ()
orderHttp conn = do
  get "/orderList" $ do
    orderList <- liftIO (selectAllOrder conn)
    json $ resultData $ A.toJSON orderList

  get "/orderById" $ do
    id <- param "id" :: ActionM TL.Text
    orders <- liftIO (selectOrderById conn id)
    json $ resultData $ A.toJSON orders

  get "/deleteOrderById" $ do
    id <- param "id" :: ActionM TL.Text
    liftIO (deleteOrderById conn id)
    json $ resultData "ok"

  post "/insertOrder" $ do
    order <- jsonData :: ActionM Order
    liftIO $ print order
    liftIO (insertOrder conn order)
    json $ resultData "ok"
    
  post "/updateOrder" $ do
    order <- jsonData :: ActionM Order
    liftIO (updateOrder conn order)
    json $ resultData "ok"
   
   
       
