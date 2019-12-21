{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
module Model.ProductComment where

import Data.Aeson 
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.ToRow
import Database.PostgreSQL.Simple.FromRow
import GHC.Generics
import Control.Monad.IO.Class
import Data.Time
import Data.Text

data ProductComment = ProductComment {
  comment_id :: Int,
  product_id :: Int,
  order_id :: Int,
  customer_id :: Int,
  audit_status :: Int,
  title :: Text,
  content :: Text,
  modified_time :: UTCTime
} deriving (Show,Generic)

instance FromRow ProductComment
instance ToRow ProductComment
instance ToJSON ProductComment       
instance FromJSON ProductComment