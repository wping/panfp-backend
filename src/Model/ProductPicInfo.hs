{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
module Model.ProductPicInfo where

import Data.Aeson 
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.ToRow
import Database.PostgreSQL.Simple.FromRow
import GHC.Generics
import Control.Monad.IO.Class
import Data.Time
import Data.Text

data ProductPicInfo = ProductPicInfo {
  product_pic_id :: Int,
  product_id :: Int,
  pic_status :: Int,
  pic_desc :: Text,
  pic_url :: Text,
  is_master :: Bool,
  modified_time :: UTCTime
} deriving (Show,Generic)

instance FromRow ProductPicInfo
instance ToRow ProductPicInfo
instance ToJSON ProductPicInfo       
instance FromJSON ProductPicInfo