{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
module Model.CustomerLevelInfo where

import Data.Aeson 
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.ToRow
import Database.PostgreSQL.Simple.FromRow
import GHC.Generics
import Control.Monad.IO.Class
import Data.Time
import Data.Text

data CustomerLevelInfo = CustomerLevelInfo {
  customer_level_id :: Int,
  min_point :: Int,
  max_point :: Int,
  level_name :: Text,
  modified_time :: UTCTime
} deriving (Show,Generic)

instance FromRow CustomerLevelInfo
instance ToRow CustomerLevelInfo
instance ToJSON CustomerLevelInfo
instance FromJSON CustomerLevelInfo