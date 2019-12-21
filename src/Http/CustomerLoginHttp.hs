{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
module Http.CustomerLoginHttp where

import Web.Scotty
import Data.Aeson (ToJSON)
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.ToField
import GHC.Generics
import Control.Monad.IO.Class
import Model.CustomerLogin
import Model.ResultData
import DB.CustomerLoginDB

import qualified Data.Text.Lazy as TL
import qualified Data.Aeson as A

customerLoginHttp :: Connection -> ScottyM ()
customerLoginHttp conn = do
  get "/customerLoginList" $ do
    customerLoginList <- liftIO (selectAllCustomerLogin conn)
    json $ resultData $ A.toJSON customerLoginList

  get "/customerLoginById" $ do
    id <- param "id" :: ActionM TL.Text
    customerLogins <- liftIO (selectCustomerLoginById conn id)
    json $ resultData $ A.toJSON customerLogins

  get "/deleteCustomerLoginById" $ do
    id <- param "id" :: ActionM TL.Text
    liftIO (deleteCustomerLoginById conn id)
    json $ resultData "ok"

  post "/insertCustomerLogin" $ do
    customerLogin <- jsonData :: ActionM CustomerLogin
    liftIO $ print customerLogin
    liftIO (insertCustomerLogin conn customerLogin)
    json $ resultData "ok"
    
  post "/updateCustomerLogin" $ do
    customerLogin <- jsonData :: ActionM CustomerLogin
    liftIO (updateCustomerLogin conn customerLogin)
    json $ resultData "ok"
   
   
       
