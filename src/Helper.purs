module Helper where

import qualified HRec as H
import qualified Data.Array as A
import Data.Maybe
import Data.String (split)
-- import Control.Lens hiding ((??), (..))
import qualified Data.Map as M
import Data.Monoid (Monoid, mempty)
-- import Control.Lens hiding ((??))
import Data.Tuple (Tuple(..))
import Debug.Trace
import Data.Foldable (foldr)

columns = ["sales", "name"]
infixr 9 ..
infixl 1 ??
infixr 6 ~
(..) = (<<<)
(??) = flip fromMaybe
(~) :: forall a b. a -> b -> Tuple a b
(~) = Tuple

clean :: String -> String
clean = fromMaybe "" .. A.last .. split "."

toFloat :: String -> String
toFloat s = "CAST (" ++ s ++ " AS FLOAT) AS " ++ clean s

calls = {floats: ["sales", "numbers", "other_numbers"],
         columns: ["names", "other_names"]}
-- x = show toFloat

prefix :: String -> String -> String
prefix s = ((++) (s ++ "."))

combine :: String -> [(String -> String)] -> [String]
combine ls fs = A.map f cs
  where cs = A.concatMap (split " ") .. split "\n" $ ls
        f s = foldr ($) s fs

newtype Col = Col ColRec
type ColRec = {floats :: [String], columns :: [String]}

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

-- modify :: forall k v . M.Map k v -> k -> (v -> v) -> M.Map k v
-- modify m k f = w
--     where v = M.lookup k m ?? mempty

h :: H.HRec [String]
h = H.insert "floats" [] H.empty

main = do
    trace "hello world!"
    print $ clean "hello. They are"
    print $ toFloat "database.sales"
    print $ ((++) "S") "database.sales"
    print $ prefix "P" "database.sales"
    -- print $ o
    print $ combine "hello there my pretties" [prefix "S"]

    let x = A.map (prefix "S") <$> H.fromList [Tuple "floats" ["sales", "numbers"]]
    trace $ showFooImpl x
    -- trace $ showFooImpl $
    print $ M.lookup "foo" lst' ?? []
    trace $ M.showTree lst'
    trace $ M.showTree $ M.map (A.map $ prefix "S") lst'
