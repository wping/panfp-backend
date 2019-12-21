{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
module Model.Warehouse where

import Data.Aeson 
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.ToRow
import Database.PostgreSQL.Simple.FromRow
import GHC.Generics
import Control.Monad.IO.Class
import Data.Time
import Data.Text

data Warehouse = Warehouse {
  w_id :: Int,
  warehouse_status :: Int,
  warehouse_sn :: Text,
  warehouse_name :: Text,
  warehouse_phone :: Text,
  contact :: Text,
  city :: Text,
  district :: Text,
  address :: Text,
  modified_time :: UTCTime
} deriving (Show,Generic)

instance FromRow Warehouse
instance ToRow Warehouse
instance ToJSON Warehouse       
instance FromJSON Warehouse