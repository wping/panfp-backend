{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
module Http.CustomerLoginLogHttp where

import Web.Scotty
import Data.Aeson (ToJSON)
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.ToField
import GHC.Generics
import Control.Monad.IO.Class
import Model.CustomerLoginLog
import Model.ResultData
import DB.CustomerLoginLogDB

import qualified Data.Text.Lazy as TL
import qualified Data.Aeson as A

customerLoginLogHttp :: Connection -> ScottyM ()
customerLoginLogHttp conn = do
  get "/customerLoginLogList" $ do
    customerLoginLogList <- liftIO (selectAllCustomerLoginLog conn)
    json $ resultData $ A.toJSON customerLoginLogList

  get "/customerLoginLogById" $ do
    id <- param "id" :: ActionM TL.Text
    customerLoginLogs <- liftIO (selectCustomerLoginLogById conn id)
    json $ resultData $ A.toJSON customerLoginLogs

  get "/deleteCustomerLoginLogById" $ do
    id <- param "id" :: ActionM TL.Text
    liftIO (deleteCustomerLoginLogById conn id)
    json $ resultData "ok"

  post "/insertCustomerLoginLog" $ do
    customerLoginLog <- jsonData :: ActionM CustomerLoginLog
    liftIO $ print customerLoginLog
    liftIO (insertCustomerLoginLog conn customerLoginLog)
    json $ resultData "ok"
    
  post "/updateCustomerLoginLog" $ do
    customerLoginLog <- jsonData :: ActionM CustomerLoginLog
    liftIO (updateCustomerLoginLog conn customerLoginLog)
    json $ resultData "ok"
   
   
       
