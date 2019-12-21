{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
module Model.ProductCategory where

import Data.Aeson 
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.ToRow
import Database.PostgreSQL.Simple.FromRow
import GHC.Generics
import Control.Monad.IO.Class
import Data.Time
import Data.Text

data ProductCategory = ProductCategory {
  category_id :: Int,
  parent_id :: Int,
  category_level :: Int,
  category_status :: Int,
  category_name :: Text,
  category_code :: Text,
  modified_time :: UTCTime
} deriving (Show,Generic)

instance FromRow ProductCategory
instance ToRow ProductCategory
instance ToJSON ProductCategory       
instance FromJSON ProductCategory