{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
module Model.CustomerLoginLog where

import Data.Aeson 
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.ToRow
import Database.PostgreSQL.Simple.FromRow
import GHC.Generics
import Control.Monad.IO.Class
import Data.Time
import Data.Text

data CustomerLoginLog = CustomerLoginLog {
  login_id :: Int,
  customer_id :: Int,
  login_type :: Int,
  login_time :: UTCTime,
  login_ip :: Text
} deriving (Show,Generic)

instance FromRow CustomerLoginLog
instance ToRow CustomerLoginLog
instance ToJSON CustomerLoginLog       
instance FromJSON CustomerLoginLog