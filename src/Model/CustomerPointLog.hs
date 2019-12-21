{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
module Model.CustomerPointLog where

import Data.Aeson 
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.ToRow
import Database.PostgreSQL.Simple.FromRow
import GHC.Generics
import Control.Monad.IO.Class
import Data.Time
import Data.Text

data CustomerPointLog = CustomerPointLog {
  point_id :: Int,
  customer_id :: Int,
  source :: Int,
  refer_number :: Int,
  change_point :: Int,
  create_time :: UTCTime
 } deriving (Show,Generic)

instance FromRow CustomerPointLog
instance ToRow CustomerPointLog
instance ToJSON CustomerPointLog       
instance FromJSON CustomerPointLog