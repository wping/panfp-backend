{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module Http.FileHttp where
import Web.Scotty
import GHC.Generics
import Control.Monad.IO.Class
import Model.ResultData
import qualified Data.Aeson as A
import Network.Wai.Parse
import qualified Web.Scotty.Internal.Types as WT
import qualified Data.ByteString.Lazy as BL
import qualified Data.ByteString as B
import Data.ByteString.UTF8 as BSU  -- from utf8-string
import System.FilePath ((</>))
import System.Directory
import Data.Time
import qualified Data.Foldable as DF
import Data.Hash.MD5

yyyymmdd ::  (IO String) -- :: (year,month,day)
yyyymmdd = do
  now <- getCurrentTime
  return (formatTime defaultTimeLocale  "%Y-%m-%d" now)

yyyymmddss ::  (IO String) --
yyyymmddss = do
  now <- getCurrentTime
  return (formatTime defaultTimeLocale  "%Y:%m:%d %H:%M:%S" now)

saveFile :: [WT.File] -> IO [FilePath]
saveFile fs = do
  dayOfFileDir <- yyyymmdd
  timeFileName <- yyyymmddss
  let path = "file_server" </>  dayOfFileDir
  createDirectoryIfMissing True (path)
  let fs' = [ (fieldName,    md5s (Str (timeFileName ++ BSU.toString (fileName fi))), fileContent fi) | (fieldName,fi) <- fs ]
  liftIO $ sequence_ [ BL.writeFile (path </> fn) fc | (_,fn,fc) <- fs' ]
  return [(path </>fn) | (_,fn,fc) <- fs']

fileHttp :: ScottyM ()
fileHttp  = do
  post "/upload" $ do
    fs <- files
    let ll = DF.length fs
       in if ll > 0
            then do
               filePath <- liftIO (saveFile fs)
               case ll of
                 1 -> json $ resultData $ A.toJSON (filePath !! 0)
                 otherwise -> json $ resultData $ A.toJSON (filePath)
            else json $ resultData "没有文件"

  get (regex "^/file_server/(.*)$") $ do
      cap <- param "1"
      file $ "file_server" </> cap


