{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
module Http.HotProductHttp where

import Web.Scotty
import Data.Aeson (ToJSON)
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.ToField
import GHC.Generics
import Control.Monad.IO.Class
import Model.HotProduct
import Model.ResultData
import DB.HotProductDB

import qualified Data.Text.Lazy as TL
import qualified Data.Aeson as A

hotProductHttp :: Connection -> ScottyM ()
hotProductHttp conn = do
  get "/hotProductList" $ do
    hotProductList <- liftIO (selectAllHotProduct conn)
    json $ resultData $ A.toJSON hotProductList

  get "/hotProductById" $ do
    id <- param "id" :: ActionM TL.Text
    hotProducts <- liftIO (selectHotProductById conn id)
    json $ resultData $ A.toJSON hotProducts

  get "/deleteHotProductById" $ do
    id <- param "id" :: ActionM TL.Text
    liftIO (deleteHotProductById conn id)
    json $ resultData "ok"

  post "/insertHotProduct" $ do
    hotProduct <- jsonData :: ActionM HotProduct
    liftIO $ print hotProduct
    liftIO (insertHotProduct conn hotProduct)
    json $ resultData "ok"
    
  post "/updateHotProduct" $ do
    hotProduct <- jsonData :: ActionM HotProduct
    liftIO (updateHotProduct conn hotProduct)
    json $ resultData "ok"
   
   
       
