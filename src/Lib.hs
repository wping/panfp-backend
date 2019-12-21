
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
module Lib where

import Data.Monoid ((<>))
import Web.Scotty
import Data.Aeson (FromJSON, ToJSON)
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.ToRow
import Database.PostgreSQL.Simple.FromRow
import Database.PostgreSQL.Simple.ToField
import GHC.Generics
import Control.Monad.IO.Class
import Data.Time
import Data.Text

import Data.ByteString
import Data.Map (Map)
import qualified Data.Map as Map
import qualified Data.Text.Lazy as TL
import qualified Data.Aeson as A


--Auth--
import Network.Wai.Middleware.HttpAuth
import Network.Wai.Middleware.RequestLogger
import Network.Wai.Middleware.AddHeaders
import Network.Wai
import Data.SecureMem -- for constant-time comparison
import Lucid -- for HTML generation


import Network.Wai.Handler.Warp
import Data.String (fromString)

import Http.BrandHttp
import Http.CustomerHttp
import Http.CustomerAddressHttp
import Http.CustomerBalanceLogHttp
import Http.CustomerLevelInfoHttp

import Http.CustomerLoginHttp
import Http.CustomerLoginLogHttp
import Http.CustomerPointLogHttp
import Http.HotProductHttp
import Http.OrderCartHttp

import Http.OrderDetailHttp
import Http.OrderHttp
import Http.ProductHttp
import Http.ProductCategoryHttp
import Http.ProductCommentHttp

import Http.ProductPicInfoHttp
import Http.ShippingHttp
import Http.SupplierHttp
import Http.WarehouseHttp
import Http.WarehouseProductHttp
import Http.FileHttp

import Network.Wai.Handler.Warp
import Data.String (fromString)
import Model.ResultData
import qualified Data.Aeson as A

import Network.Wai.Parse
import qualified Web.Scotty.Internal.Types as WT
import qualified Data.ByteString.Char8 as BS
import qualified Data.ByteString.Lazy as B
import System.FilePath ((</>))
import System.Directory
--cor option
protectedResources :: Request -> IO Bool
protectedResources request = do
    let method = requestMethod request
    return $ protect method
      where protect "GET" = True
            protect "POST" = True
            protect _  = False

password :: SecureMem
password = secureMemFromByteString "123456" -- https://xkcd.com/221/


server :: Connection -> ScottyM ()
server conn = do
  middleware $ logStdout
  middleware $ addHeaders [("Access-Control-Expose-Headers", "*" ),
                           ("Access-Control-Allow-Headers", "Content-Type,Access-Token,Authorization,x-requested-with"),
                           ("Access-Control-Allow-Methods","*"),
                           ("Access-Control-Allow-Credentials","true"),
                           ("Access-Control-Allow-Origin","*")
                           ]
--  middleware $ basicAuth (\u p -> return $ u == "user" && secureMemFromByteString p == password)
--     "Panfp Realm" { authIsProtected = protectedResources }
  options "/:url" $ do
    text "ok"

  brandHttp conn
  customerHttp conn
  customerAddressHttp conn
  customerBalanceLogHttp conn
  customerLevelInfoHttp conn

  customerLoginHttp conn
  customerLoginLogHttp conn
  customerPointLogHttp conn
  hotProductHttp conn
  orderCartHttp conn

  orderDetailHttp conn
  orderHttp conn
  productHttp conn
  productCategoryHttp conn
  productCommentHttp conn

  productPicInfoHttp conn
  shippingHttp conn
  supplierHttp conn
  warehouseHttp conn
  warehouseProductHttp conn
  
  fileHttp

startServer :: IO ()
startServer = do
  conn <- connectPostgreSQL ("host='127.0.0.1' user='test' dbname='test' password='111111'")
  scotty 9527 $ server conn