module Helper where

import Data.Array hiding ((..))
import Data.Maybe
import Data.String (split)
import Control.Lens hiding ((??), (..))
-- import Control.Lens hiding ((??))

import Debug.Trace

columns = ["sales", "name"]
infixr 9 ..
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
-- z = _col .. _floats

type Foo =
  { foo :: {bar :: Number}
  , baz :: Boolean
  }

foo :: forall a b r. Lens {foo :: a | r} {foo :: b | r} a b
foo = lens (\o -> o.foo) (\o x -> o{foo = x})
foo' :: forall a b r. Lens {foo :: a | r} {foo :: b | r} a b
foo' = foo
bar :: forall a b r. Lens {bar :: a | r} {bar :: b | r} a b
bar = lens (\o -> o.bar) (\o x -> o{bar = x})
baz :: forall a b r. Lens {baz :: a | r} {baz :: b | r} a b
baz = lens (\o -> o.baz) (\o x -> o{baz = x})

fooBar :: forall a b r r'. Lens {foo :: {bar :: a | r} | r'} {foo :: {bar :: b | r} | r'} a b
fooBar = foo..bar

obj :: Foo
obj = {foo: {bar: 0}, baz: true}

succ x = x + 1

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
    print $ Col .. over _floats ff $ c
    print $ Col .. (_floats %~ ff) $ c
    -- print' $ (_floats %~ ff) $ c
    print' $ _col .. _floats %~ ff $ o
    -- print $ Col .. _floats %~ ff $ (o ^. _col)
    -- print $ Col .. _floats %~ ff .. _col $ o
    -- trace $ showFooImpl $ (foo' .. bar) .~ 10 $ obj
    -- trace $ showFooImpl $ foo' .. (bar .~ 10) $ obj
    -- trace $ show (foo' .. bar)
    -- let x = over _floats ff c

    -- print $ Col x
    -- print $ over (++ ["new item"])

-- (indent-for-tab-command)
-- purescript-mode-suggest-indent-choice
