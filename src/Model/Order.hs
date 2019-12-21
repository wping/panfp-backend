{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
module Model.Order where


import Data.Aeson 
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.ToRow
import Database.PostgreSQL.Simple.FromRow
import Database.PostgreSQL.Simple.ToField
import GHC.Generics
import Control.Monad.IO.Class
import Data.Time
import Data.Text

import qualified Data.List as DL
import Control.Applicative
import qualified Database.PostgreSQL.Simple.ToRow as ST

data Order = Order {
  order_id :: Maybe Int, 
  customer_id :: Int,
  payment_method :: Int, 
  order_money :: Double, 
  district_money :: Double,
  shipping_money :: Double,
  payment_money :: Double,
  shipping_time :: UTCTime, 
  pay_time :: UTCTime, 
  receive_time :: UTCTime, 
  order_status :: Int, 
  order_point :: Int, 
  shipping_user :: Text, 
  province :: Text, 
  city :: Text,
  district :: Text, 
  address :: Text, 
  invoice_title :: Text, 
  shipping_comp_name :: Text, 
  shipping_sn :: Text, 
  order_sn :: Text, 
  create_time :: Maybe UTCTime, 
  modified_time :: Maybe UTCTime
} deriving (Show,Generic)

instance FromRow Order
instance ToRow Order
instance ToJSON Order       
instance FromJSON Order

toInsertRow p = do
              let a = ST.toRow p
              let b = DL.drop 1 a
              DL.take 20 b