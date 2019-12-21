{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
module Model.WarehouseProduct where

import Data.Aeson 
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.ToRow
import Database.PostgreSQL.Simple.FromRow
import GHC.Generics
import Control.Monad.IO.Class
import Data.Time
import Data.Text

data WarehouseProduct = WarehouseProduct {
  wp_id :: Int,
  product_id :: Int,
  w_id :: Int,
  current_cnt :: Int,
  lock_cnt :: Int,
  in_transit_cnt :: Int,
  average_cost :: Double,
  modified_time :: UTCTime
} deriving (Show,Generic)

instance FromRow WarehouseProduct
instance ToRow WarehouseProduct
instance ToJSON WarehouseProduct       
instance FromJSON WarehouseProduct