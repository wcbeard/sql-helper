module HRec where
-- Ripped from https://github.com/paf31/purescript-book
import Data.Function
-- import qualified Data.Array as A
import Data.Foldable (foldr)
import Data.Tuple (Tuple(..))

foreign import data HRec :: * -> *

instance showHRec :: (Show a) => Show (HRec a) where
  show rec = "HRec { " ++ Data.String.joinWith ", " (foldHRec f [] rec) ++ " }"
    where
    f = mkFn3 $ \ss k a -> (show k ++ ": " ++ show a) : ss

foreign import empty
  "var empty = {}" :: forall a. HRec a

foreign import insertFn
  "function insertFn(key, value, rec) {\
  \  var copy = {};\
  \  for (var k in rec) {\
  \    if (rec.hasOwnProperty(k)) {\
  \      copy[k] = rec[k];\
  \    }\
  \  }\
  \  copy[key] = value;\
  \  return copy;\
  \}" :: forall a. Fn3 String a (HRec a) (HRec a)

insert :: forall a. String -> a -> (HRec a) -> (HRec a)
insert = runFn3 insertFn

foreign import mapHRecFn
  "function mapHRecFn(f, rec) {\
  \  var mapped = {};\
  \  for (var k in rec) {\
  \    if (rec.hasOwnProperty(k)) {\
  \      mapped[k] = f(rec[k]);\
  \    }\
  \  }\
  \  return mapped;\
  \}" :: forall a b. Fn2 (a -> b) (HRec a) (HRec b)

mapHRec :: forall a b. (a -> b) -> (HRec a) -> (HRec b)
mapHRec = runFn2 mapHRecFn

instance functorHRec :: Functor HRec where
  (<$>) = mapHRec

foreign import foldHRecFn
  "function foldHRecFn(f, r, rec) {\
  \  var acc = r;\
  \  for (var k in rec) {\
  \    if (rec.hasOwnProperty(k)) {\
  \      acc = f(acc, k, rec[k]);\
  \    }\
  \  }\
  \  return acc;\
  \}" :: forall a r. Fn3 (Fn3 r String a r) r (HRec a) r

foldHRec :: forall a r. (Fn3 r String a r) -> r -> (HRec a) -> r
foldHRec = runFn3 foldHRecFn

fromList :: forall a. [Tuple String a] -> HRec a
fromList l = foldr f empty l
  where f (Tuple label val) hrec = insert label val hrec
