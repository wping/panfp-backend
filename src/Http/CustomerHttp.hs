{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
module Http.CustomerHttp where

import Web.Scotty
import Data.Aeson (ToJSON)
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.ToField
import GHC.Generics
import Control.Monad.IO.Class
import Model.Customer
import Model.ResultData
import DB.CustomerDB

import qualified Data.Text.Lazy as TL
import qualified Data.Aeson as A

customerHttp :: Connection -> ScottyM ()
customerHttp conn = do
  get "/customerList" $ do
    customerList <- liftIO (selectAllCustomer conn)
    json $ resultData $ A.toJSON customerList

  get "/customerById" $ do
    id <- param "id" :: ActionM TL.Text
    customers <- liftIO (selectCustomerById conn id)
    json $ resultData $ A.toJSON customers

  get "/deleteCustomerById" $ do
    id <- param "id" :: ActionM TL.Text
    liftIO (deleteCustomerById conn id)
    json $ resultData "ok"

  post "/insertCustomer" $ do
    customer <- jsonData :: ActionM Customer
    liftIO $ print customer
    liftIO (insertCustomer conn customer)
    json $ resultData "ok"
    
  post "/updateCustomer" $ do
    customer <- jsonData :: ActionM Customer
    liftIO (updateCustomer conn customer)
    json $ resultData "ok"
   
   
       
