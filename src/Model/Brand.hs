{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
module Model.Brand where

import Data.Aeson 
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.ToRow
import Database.PostgreSQL.Simple.FromRow
import GHC.Generics
import Control.Monad.IO.Class
import Data.Time
import Data.Text

data Brand = Brand {
  web :: Text,
  logo :: Text,
  name :: Text,
  brand_id :: Int,
  modified_time :: UTCTime
} deriving (Show,Generic)

instance FromRow Brand
instance ToRow Brand
instance ToJSON Brand       
instance FromJSON Brand