{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module DB.BrandDB where
import Database.PostgreSQL.Simple
import Model.Brand
import qualified Data.Text.Lazy as TL

insertBrandQuery = "insert into brand (web,name,logo) values (?,?,?) returning brand_id"
updateBrandQuery = "update brand set web=?,name=?,logo=? where brand_id=?"
selectAllBrandQuery = "select * from brand"
selectBrandByIdQuery = "select * from brand where brand_id in ?"
deleteBrandByIdQuery = "delete from brand where brand_id in ?"

insertBrand :: Connection -> Brand -> IO Brand
insertBrand conn item = do
    [Only cid] <- query conn insertBrandQuery item
    return item { brand_id = cid }

updateBrand :: Connection -> Brand -> IO ()
updateBrand conn item = do
     execute conn updateBrandQuery item
     return ()

selectAllBrand :: Connection -> IO [Brand]
selectAllBrand conn = do
     query_ conn selectAllBrandQuery :: IO [Brand]

selectBrandById :: Connection -> TL.Text -> IO [Brand]
selectBrandById conn id = do
     query conn  selectBrandByIdQuery  (Only (In [id])) :: IO [Brand]

deleteBrandById :: Connection -> TL.Text -> IO ()
deleteBrandById conn id = do
     execute conn deleteBrandByIdQuery (Only (In [id]))
     return ()