{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
module Model.Product where

import Data.Aeson 
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.FromRow
import Database.PostgreSQL.Simple.ToField
import GHC.Generics
import Control.Monad.IO.Class
import Data.Time
import Data.Text
import qualified Data.List as DL
import Control.Applicative
import qualified Database.PostgreSQL.Simple.ToRow as ST


data Product = Product {
  product_id :: Maybe Int,
  brand_id :: Int,
  one_category_id :: Int,
  two_category_id :: Int,
  supplier_id :: Int,
  price :: Double,
  average_cost :: Double,
  publish_status :: Int,
  audit_status :: Int,
  weight :: Double,
  length :: Double,
  height :: Double,
  width :: Double,
  production_date :: Day,
  shelf_life :: Int,
  product_core :: Text,
  product_name :: Text,
  bar_code :: Text,
  color_type :: Text,
  description :: Text,
  indate :: UTCTime,
  modified_time :: Maybe UTCTime
} deriving (Show,Generic)

instance FromRow Product
instance ToRow Product
instance ToJSON Product       
instance FromJSON Product

toInsertRow p = do
              let a = ST.toRow p
              let b = DL.drop 1 a
              DL.take 20 b



--where
--parseJSON (Object v) = Product <$>
--                            v .:? "product_id" .!= 0 <*> -- the field "id" is optional
--                            v .:  "brand_id"    <*>
--                            v .:  "one_category_id" <*>
--                            v .:  "two_category_id" <*>
--                            v .:  "supplier_id" <*>
--                            v .:  "price" <*>
--                            v .:  "average_cost" <*>
--
--                            v .:  "publish_status" <*>
--                            v .:  "audit_status" <*>
--                            v .:  "weight" <*>
--                            v .:  "length" <*>
--                            v .:  "height" <*>
--
--                            v .:  "width" <*>
--                            v .:  "production_date" <*>
--                            v .:  "shelf_life" <*>
--                            v .:  "product_core" <*>
--                            v .:  "product_name" <*>
--
--                            v .:  "bar_code" <*>
--                            v .:  "color_type" <*>
--                            v .:  "description" <*>
--                            v .:  "indate" <*>
--                            v .:  "modified_time"
