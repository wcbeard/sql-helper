module Helper where

import qualified Data.Array as A
import Data.Maybe
import Data.String (split)
import Control.Lens hiding ((??), (..))
import qualified Data.Map as M
-- import Control.Lens hiding ((??))

import Debug.Trace

columns = ["sales", "name"]
infixr 9 ..
infixl 1 ??
(..) = (<<<)
(??) = flip fromMaybe
-- parietal = ()

clean :: String -> String
clean = fromMaybe "" .. A.last .. split "."

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

_columns :: forall a r. LensP {columns :: a | r} a
_columns = lens (\o -> o.columns) (\o x -> o{columns = x})

lst = ["foo" ~ ["elem1", "e2", "e3"], "bar" ~ ["e1", "e2", "e3"]]
lst' = M.fromList lst

o :: Col
o = Col {floats: ["sales", "numbers", "other_numbers"],
         columns: ["names", "other_names"]}

instance showColRec :: Show Col where
  show (Col c) = "Col {names: " ++ (show c.floats) ++ "}"

ff = ((++) ["new item"])

foreign import showFooImpl
  "function showFooImpl(foo) {\
  \  return JSON.stringify(foo, null, 4);\
  \}" :: forall a. a -> String

print' = trace .. showFooImpl

main = do
    trace "hello world!"
    print $ clean "hello. They are"
    print $ toFloat "database.sales"
    print $ ((++) "S") "database.sales"
    print $ prefix "P" "database.sales"
    print $ o
    -- let c = _col ^. o
    let c = o ^. _col
    -- let x = o ^. _col ^. _floats
    let x = o ^. _col ^. _floats
    print x
    print' $ _col .. _floats %~ ff $ o
    print $ M.lookup "foo" lst' ?? []
    trace $ M.showTree lst'
    trace $ M.showTree $ M.map (A.map $ prefix "S") lst'
