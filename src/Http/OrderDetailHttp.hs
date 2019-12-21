{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
module Http.OrderDetailHttp where

import Web.Scotty
import Data.Aeson (ToJSON)
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.ToField
import GHC.Generics
import Control.Monad.IO.Class
import Model.OrderDetail
import Model.ResultData
import DB.OrderDetailDB

import qualified Data.Text.Lazy as TL
import qualified Data.Aeson as A

orderDetailHttp :: Connection -> ScottyM ()
orderDetailHttp conn = do
  get "/orderDetailList" $ do
    orderDetailList <- liftIO (selectAllOrderDetail conn)
    json $ resultData $ A.toJSON orderDetailList

  get "/orderDetailById" $ do
    id <- param "id" :: ActionM TL.Text
    orderDetails <- liftIO (selectOrderDetailById conn id)
    json $ resultData $ A.toJSON orderDetails

  get "/orderDetailByOrderId" $ do
    id <- param "id" :: ActionM TL.Text
    orderDetails <- liftIO (selectOrderDetailByOrderId conn id)
    json $ resultData $ A.toJSON orderDetails
    
  get "/deleteOrderDetailById" $ do
    id <- param "id" :: ActionM TL.Text
    liftIO (deleteOrderDetailById conn id)
    json $ resultData "ok"

  post "/insertOrderDetail" $ do
    orderDetail <- jsonData :: ActionM OrderDetail
    liftIO $ print orderDetail
    liftIO (insertOrderDetail conn orderDetail)
    json $ resultData "ok"
    
  post "/updateOrderDetail" $ do
    orderDetail <- jsonData :: ActionM OrderDetail
    liftIO (updateOrderDetail conn orderDetail)
    json $ resultData "ok"
   
   
       
