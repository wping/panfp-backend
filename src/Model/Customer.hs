{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
module Model.Customer where

import Data.Aeson
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.ToRow
import Database.PostgreSQL.Simple.FromRow
import Database.PostgreSQL.Simple.ToField
import GHC.Generics
import Data.Time
import Data.Text
import qualified Data.List as DL
import Control.Applicative
import qualified Database.PostgreSQL.Simple.ToRow as ST

data Customer = Customer {
  customer_id :: Maybe Int,
  phone :: Text,
  name :: Text,
  gender :: Bool,
  point :: Int,
  birthday :: Day,
  rank :: Int,
  balance :: Double,
  register_time :: Maybe UTCTime,
  modified_time :: Maybe UTCTime
} deriving (Show,Generic)

instance FromRow Customer 
instance ToRow Customer 
instance ToJSON Customer 
instance FromJSON Customer

toInsertRow p = do
              let a = ST.toRow p
              let b = DL.drop 1 a
              DL.take 7 b