{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
module Model.OrderDetail where

import Data.Aeson 
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.ToRow
import Database.PostgreSQL.Simple.FromRow
import GHC.Generics
import Control.Monad.IO.Class
import Data.Time
import Data.Text

import qualified Data.List as DL
import Control.Applicative
import qualified Database.PostgreSQL.Simple.ToRow as ST

data OrderDetail = OrderDetail {
  order_detail_id :: Maybe Int,
  order_id :: Int,
  product_id :: Int,
  product_cnt :: Int,
  product_price :: Double,
  average_cost :: Double,
  weight :: Double,
  fee_money :: Double,
  w_id :: Int,
  product_name :: Text,
  modified_time :: Maybe UTCTime
} deriving (Show,Generic)

instance FromRow OrderDetail
instance ToRow OrderDetail
instance ToJSON OrderDetail       
instance FromJSON OrderDetail

toInsertRow p = do
              let a = ST.toRow p
              let b = DL.drop 1 a
              DL.take 9 b