{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
module Model.HotProduct where

import Data.Aeson 
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.ToRow
import Database.PostgreSQL.Simple.FromRow
import Database.PostgreSQL.Simple.ToField
import GHC.Generics
import Control.Monad.IO.Class
import Data.Time
import Data.Text

data HotProduct = HotProduct {
  hotproduct_id :: Int,
  brand_id :: Int,
  status :: Int,
  order_id :: Int
} deriving (Show,Generic)

instance FromRow HotProduct
instance ToRow HotProduct
instance ToJSON HotProduct       
instance FromJSON HotProduct