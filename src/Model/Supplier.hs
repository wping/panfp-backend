{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
module Model.Supplier where

import Data.Aeson 
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.ToRow
import Database.PostgreSQL.Simple.FromRow
import GHC.Generics
import Control.Monad.IO.Class
import Data.Time
import Data.Text

data Supplier = Supplier {
  supplier_id :: Int,
  supplier_type :: Int,
  supplier_status :: Int,
  supplier_code :: Text,
  supplier_name :: Text,
  link_man :: Text,
  phone :: Text,
  bank_name :: Text,
  bank_account :: Text,
  address :: Text,
  modified_time :: UTCTime
} deriving (Show,Generic)

instance FromRow Supplier
instance ToRow Supplier
instance ToJSON Supplier       
instance FromJSON Supplier