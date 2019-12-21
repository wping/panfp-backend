{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module Model.CustomerAddress where
import Data.Aeson
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.ToRow
import Database.PostgreSQL.Simple.FromRow
import Database.PostgreSQL.Simple.ToField
import GHC.Generics
import Data.Time
import Data.Text

data CustomerAddress = CustomerAddress {
  customer_addr_id :: Integer,
  customer_id :: Integer,
  zip :: Int,
  is_default :: Bool,
  province :: Text,
  city :: Text,
  district :: Text,
  address :: Text,
  modified_time :: UTCTime
} deriving (Show,Generic)

instance FromRow CustomerAddress
instance ToRow CustomerAddress
instance ToJSON CustomerAddress
instance FromJSON CustomerAddress
