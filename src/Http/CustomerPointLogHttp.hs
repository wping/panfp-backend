{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
module Http.CustomerPointLogHttp where

import Web.Scotty
import Data.Aeson (ToJSON)
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.ToField
import GHC.Generics
import Control.Monad.IO.Class
import Model.CustomerPointLog
import Model.ResultData
import DB.CustomerPointLogDB

import qualified Data.Text.Lazy as TL
import qualified Data.Aeson as A

customerPointLogHttp :: Connection -> ScottyM ()
customerPointLogHttp conn = do
  get "/customerPointLogList" $ do
    customerPointLogList <- liftIO (selectAllCustomerPointLog conn)
    json $ resultData $ A.toJSON customerPointLogList

  get "/customerPointLogById" $ do
    id <- param "id" :: ActionM TL.Text
    customerPointLogs <- liftIO (selectCustomerPointLogById conn id)
    json $ resultData $ A.toJSON customerPointLogs

  get "/deleteCustomerPointLogById" $ do
    id <- param "id" :: ActionM TL.Text
    liftIO (deleteCustomerPointLogById conn id)
    json $ resultData "ok"

  post "/insertCustomerPointLog" $ do
    customerPointLog <- jsonData :: ActionM CustomerPointLog
    liftIO $ print customerPointLog
    liftIO (insertCustomerPointLog conn customerPointLog)
    json $ resultData "ok"
    
  post "/updateCustomerPointLog" $ do
    customerPointLog <- jsonData :: ActionM CustomerPointLog
    liftIO (updateCustomerPointLog conn customerPointLog)
    json $ resultData "ok"
   
   
       
