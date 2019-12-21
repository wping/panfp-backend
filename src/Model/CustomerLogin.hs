{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
module Model.CustomerLogin where

import Data.Aeson 
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.ToRow
import Database.PostgreSQL.Simple.FromRow
import GHC.Generics
import Control.Monad.IO.Class
import Data.Time
import Data.Text

data CustomerLogin = CustomerLogin {
  customer_id :: Int,
  user_status :: Int,
  login_name :: Text,
  password :: Text,
  modified_time :: UTCTime
} deriving (Show,Generic)

instance FromRow CustomerLogin
instance ToRow CustomerLogin
instance ToJSON CustomerLogin       
instance FromJSON CustomerLogin