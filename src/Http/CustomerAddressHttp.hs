{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
module Http.CustomerAddressHttp where

import Web.Scotty
import Data.Aeson (ToJSON)
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.ToField
import GHC.Generics
import Control.Monad.IO.Class
import Model.CustomerAddress
import Model.ResultData
import DB.CustomerAddressDB

import qualified Data.Text.Lazy as TL
import qualified Data.Aeson as A

customerAddressHttp :: Connection -> ScottyM ()
customerAddressHttp conn = do
    get "/customerAddressList" $ do
      customerAddressList <- liftIO (selectAllCustomerAddress conn)
      json $ resultData $ A.toJSON customerAddressList
   
    get "/customerAddressById" $ do
      id <- param "id" :: ActionM TL.Text
      addresses <- liftIO (selectCustomerAddressById conn id)
      json $ resultData $ A.toJSON addresses
   
    get "/deleteCustomerAddressById" $ do
      id <- param "id" :: ActionM TL.Text
      liftIO (deleteCustomerAddressById conn id)
      json $ resultData "ok"
      
    post "/insertCustomerAddress" $ do
      address <- jsonData :: ActionM CustomerAddress
      liftIO $ print address
      liftIO (insertCustomerAddress conn address)
      json $ resultData "ok"
   
    post "/updateCustomerAddress" $ do
      address <- jsonData :: ActionM CustomerAddress
      liftIO (updateCustomerAddress conn address)
      json $ resultData "ok"
   
   
       
