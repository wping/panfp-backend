{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module Model.ResultData where
import Data.Aeson
import GHC.Generics

data ResultData = ResultData { 
  result::Value,
  code::Int,
  msg::String
  } deriving (Show,Generic)

instance ToJSON ResultData;

-- instance ToJSON ResultObject;
resultData :: Value -> ResultData
resultData a = ResultData {code = 0,result = a, msg = "ok"}

