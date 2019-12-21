{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
module Http.OrderCartHttp where

import Web.Scotty
import Data.Aeson (ToJSON)
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.ToField
import GHC.Generics
import Control.Monad.IO.Class
import Model.OrderCart
import Model.ResultData
import DB.OrderCartDB

import qualified Data.Text.Lazy as TL
import qualified Data.Aeson as A

orderCartHttp :: Connection -> ScottyM ()
orderCartHttp conn = do
  get "/orderCartList" $ do
    orderCartList <- liftIO (selectAllOrderCart conn)
    json $ resultData $ A.toJSON orderCartList

  get "/orderCartById" $ do
    id <- param "id" :: ActionM TL.Text
    orderCarts <- liftIO (selectOrderCartById conn id)
    json $ resultData $ A.toJSON orderCarts

  get "/deleteOrderCartById" $ do
    id <- param "id" :: ActionM TL.Text
    liftIO (deleteOrderCartById conn id)
    json $ resultData "ok"

  post "/insertOrderCart" $ do
    orderCart <- jsonData :: ActionM OrderCart
    liftIO $ print orderCart
    liftIO (insertOrderCart conn orderCart)
    json $ resultData "ok"
    
  post "/updateOrderCart" $ do
    orderCart <- jsonData :: ActionM OrderCart
    liftIO (updateOrderCart conn orderCart)
    json $ resultData "ok"
   
   
       
