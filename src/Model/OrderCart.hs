{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
module Model.OrderCart where

import Data.Aeson 
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.ToRow
import Database.PostgreSQL.Simple.FromRow
import GHC.Generics
import Control.Monad.IO.Class
import Data.Time
import Data.Text

data OrderCart = OrderCart {
  cart_id :: Int,
  customer_id :: Int,
  product_id :: Int,
  product_amount :: Int,
  price :: Double,
  add_time :: UTCTime,
  modified_time :: UTCTime
} deriving (Show,Generic)

instance FromRow OrderCart
instance ToRow OrderCart
instance ToJSON OrderCart       
instance FromJSON OrderCart