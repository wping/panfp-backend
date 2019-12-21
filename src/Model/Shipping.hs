{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
module Model.Shipping where

import Data.Aeson 
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.ToRow
import Database.PostgreSQL.Simple.FromRow
import GHC.Generics
import Control.Monad.IO.Class
import Data.Time
import Data.Text

data Shipping = Shipping {
  ship_id :: Int,
  ship_name :: Text,
  ship_contact :: Text,
  phone :: Text,
  price :: Double,
  modified_time :: UTCTime
} deriving (Show,Generic)

instance FromRow Shipping
instance ToRow Shipping
instance ToJSON Shipping       
instance FromJSON Shipping