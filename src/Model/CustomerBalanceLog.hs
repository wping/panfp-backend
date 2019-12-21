{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
module Model.CustomerBalanceLog where

import Data.Aeson 
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.ToRow
import Database.PostgreSQL.Simple.FromRow
import GHC.Generics
import Control.Monad.IO.Class
import Data.Time
import Data.Text

data CustomerBalanceLog = CustomerBalanceLog {
  balance_id :: Int,
  customer_id :: Int,
  source :: Int,
  amount :: Double,
  source_sn :: Text,
  modified_time :: UTCTime
} deriving (Show,Generic)

instance FromRow CustomerBalanceLog
instance ToRow CustomerBalanceLog
instance ToJSON CustomerBalanceLog       
instance FromJSON CustomerBalanceLog