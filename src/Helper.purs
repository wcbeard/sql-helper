module Helper where

import qualified HRec as H
import qualified Data.Array as A
import qualified Data.Map as M
import Data.Maybe (fromMaybe)
import Data.String (split, joinWith)
import Data.Tuple (Tuple(..))
import Debug.Trace (trace, print)
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

prefix :: String -> String -> String
prefix s = ((++) (s ++ "."))

combine :: String -> [(String -> String)] -> String
combine ls fs = joinWith ", " $ A.map f cs
  where cs = A.concatMap (split " ") .. split "\n" $ ls
        f s = foldr ($) s fs

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

    print $ combine "hello there my pretties" [prefix "S"]

    -- try homogeneous records
    let x = A.map (prefix "S") <$> H.fromList [Tuple "floats" ["sales", "numbers"]]
    trace $ showFooImpl x

    -- try maps
    let lst = ["foo" ~ ["elem1", "e2", "e3"], "bar" ~ ["e1", "e2", "e3"]]
    let lst' = M.fromList lst
    print $ M.lookup "foo" lst' ?? []
    trace $ M.showTree lst'
    trace $ M.showTree $ M.map (A.map $ prefix "S") lst'
