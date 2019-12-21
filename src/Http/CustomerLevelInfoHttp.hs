{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
module Http.CustomerLevelInfoHttp where

import Web.Scotty
import Data.Aeson (ToJSON)
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.ToField
import GHC.Generics
import Control.Monad.IO.Class
import Model.CustomerLevelInfo
import Model.ResultData
import DB.CustomerLevelInfoDB

import qualified Data.Text.Lazy as TL
import qualified Data.Aeson as A

customerLevelInfoHttp :: Connection -> ScottyM ()
customerLevelInfoHttp conn = do
  get "/customerLevelInfoList" $ do
    customerLevelInfoList <- liftIO (selectAllCustomerLevelInfo conn)
    json $ resultData $ A.toJSON customerLevelInfoList

  get "/customerLevelInfoById" $ do
    id <- param "id" :: ActionM TL.Text
    customerLevelInfos <- liftIO (selectCustomerLevelInfoById conn id)
    json $ resultData $ A.toJSON customerLevelInfos

  get "/deleteCustomerLevelInfoById" $ do
    id <- param "id" :: ActionM TL.Text
    liftIO (deleteCustomerLevelInfoById conn id)
    json $ resultData "ok"

  post "/insertCustomerLevelInfo" $ do
    customerLevelInfo <- jsonData :: ActionM CustomerLevelInfo
    liftIO $ print customerLevelInfo
    liftIO (insertCustomerLevelInfo conn customerLevelInfo)
    json $ resultData "ok"
    
  post "/updateCustomerLevelInfo" $ do
    customerLevelInfo <- jsonData :: ActionM CustomerLevelInfo
    liftIO (updateCustomerLevelInfo conn customerLevelInfo)
    json $ resultData "ok"
   
   
       
