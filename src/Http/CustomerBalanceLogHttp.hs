{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
module Http.CustomerBalanceLogHttp where

import Web.Scotty
import Data.Aeson (ToJSON)
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.ToField
import GHC.Generics
import Control.Monad.IO.Class
import Model.CustomerBalanceLog
import Model.ResultData
import DB.CustomerBalanceLogDB

import qualified Data.Text.Lazy as TL
import qualified Data.Aeson as A

customerBalanceLogHttp :: Connection -> ScottyM ()
customerBalanceLogHttp conn = do
  get "/customerBalanceLogList" $ do
    customerBalanceLogList <- liftIO (selectAllCustomerBalanceLog conn)
    json $ resultData $ A.toJSON customerBalanceLogList

  get "/customerBalanceLogById" $ do
    id <- param "id" :: ActionM TL.Text
    customerBalanceLogs <- liftIO (selectCustomerBalanceLogById conn id)
    json $ resultData $ A.toJSON customerBalanceLogs

  get "/deleteCustomerBalanceLogById" $ do
    id <- param "id" :: ActionM TL.Text
    liftIO (deleteCustomerBalanceLogById conn id)
    json $ resultData "ok"

  post "/insertCustomerBalanceLog" $ do
    customerBalanceLog <- jsonData :: ActionM CustomerBalanceLog
    liftIO $ print customerBalanceLog
    liftIO (insertCustomerBalanceLog conn customerBalanceLog)
    json $ resultData "ok"
    
  post "/updateCustomerBalanceLog" $ do
    customerBalanceLog <- jsonData :: ActionM CustomerBalanceLog
    liftIO (updateCustomerBalanceLog conn customerBalanceLog)
    json $ resultData "ok"
   
   
       
