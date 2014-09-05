module Helper where

import Data.Array hiding ((..))
import Data.Maybe
import Data.String (split)

import Debug.Trace

columns = ["sales", "name"]
infixl 1 ..
infixl 1 ??
(..) = (<<<)
(??) = flip fromMaybe
-- parietal = ()

clean :: String -> String
clean = fromMaybe "" .. last .. split "."

toFloat :: String -> String
toFloat s = "CAST (" ++ s ++ " AS FLOAT) AS " ++ clean s

calls = {floats: ["sales", "numbers", "other_numbers"],
         columns: ["names", "other_names"]}
-- x = show toFloat

main = do
    trace "hello world!"
    print $ clean "hello. They are"
    print $ toFloat "database.sales"
