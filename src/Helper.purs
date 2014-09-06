module Helper where

import Data.Array hiding ((..))
import Data.Maybe
import Data.String (split)
import Control.Lens hiding ((??), (..))

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

prefix s = ((++) (s ++ "."))

newtype Col = Col ColRec
type ColRec = {floats :: [String], columns :: [String]}

_col :: LensP Col ColRec
_col f (Col crec) = Col <$> f crec

_floats :: forall a r. LensP {floats :: a | r} a
_floats = lens (\o -> o.floats) (\o x -> o{floats = x})

o :: Col
o = Col {floats: ["sales", "numbers", "other_numbers"],
         columns: ["names", "other_names"]}

instance showColRec :: Show Col where
  show (Col c) = "Col {names: " ++ (show c.floats) ++ "}"

ff = ((++) ["new item"])

main = do
    trace "hello world!"
    print $ clean "hello. They are"
    print $ toFloat "database.sales"
    print $ ((++) "S") "database.sales"
    print $ prefix "P" "database.sales"
    print $ o
    -- let c = _col ^. o
    let c = o ^. _col
    let x = over _floats ff c
    -- print $ Col <$> x
    print $ Col x
    -- print $ over (++ ["new item"])

-- (indent-for-tab-command)
-- purescript-mode-suggest-indent-choice
