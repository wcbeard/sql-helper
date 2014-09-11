module Todomvc.Controller (todoctrl) where

-- import qualified Data.Array as A
-- import qualified Data.String as S
-- import Data.Foldable
-- import Data.Maybe
-- import Control.Monad (unless, when)
import Control.Monad.Eff (Eff())
import qualified Helper as H
import Helper ((..), prefix, combine, toFloat)
import Debug.Trace (trace)
import Data.Array (append, snoc)

-- import Control.Monad.ST (ST(), STArray(), newSTArray, runSTArray)

-- import Angular (copy, extend)
import Angular.Scope (Scope(), readScope, extendScope, modifyScope, WriteEff(..))
-- import Angular.Scope (Scope(), watch, readScope, extendScope, modifyScope)
-- import Angular.This(readThis, writeThis)
-- import Angular.ST (readSTArray, pushSTArray, pushAllSTArray, writeSTArray, spliceSTArray)

foreign import printer
"function printer(a){\
\ console.log(a); \
\ }" :: forall a. a -> a


testControllerX scope scopeElem = do
    -- Stuff successfully logs here with let statement
    let x = printer scope
    let x = trace "I can see this"
    extendScope scopeElem scope  -- This does not execute
    -- extendScope {todo: "have dinner"} scope  -- This does not execute
    let x = trace "I can't see this"
    x

-- testController :: forall a b c. Scope a -> String -> WriteEff c
testController scope a = do
    -- let x = printer a
    let x'' = printer scope
    extendScope {todo: "dennard dinner "} scope
    extendScope {dinner: a} scope
    let x' = printer scope
    -- return x
    return $ \_ -> printer "Done!"

testController' scope a = do
    -- Stuff successfully logs here with let statement
    let x = trace "I can see this if x is returned"
    trace "I can see this, when I call the resulting function"
    extendScope {todo: "have dinner"} scope  -- This does not execute
    let x' = trace "I can't see this"
    x
    -- return $ \_ -> trace "Done!"
    -- return $ \_ -> (x)

-- b = show testControllerX
-- x = show  id
controller scope = do
  extendScope {newTodo: "hello?"
              , trace: printer
              -- , testControllerS: testController scope
              , testControllerS: unsafeRunEff .. testController' scope
              , testControllerE: unsafeRunEff .. testControllerX scope
              , testController': unsafeRunEff .. testControllerX scope
              , prefix: prefix
              , combine: combine
              , showScope: (\_ -> printer scope)
              , transforms: {float: toFloat, none: (\a->a)}
              , selects: [{}]
              -- , increment: flip snoc {}
              -- , increment: snoc {}
              , increment: increment scope
              } scope
  return $ printer scope

increment scope = modifyScope (\s -> do
      -- preve <- readScope s
      return {selects: snoc s.selects {}}
    ) scope

foreign import todoctrl
  " /*@ngInject*/function todoctrl($scope) { \
  \   var impl = controller($scope); \
  \   return impl.apply(this, []); \
  \ } "
  :: forall e a. Scope a -> Eff e Unit

foreign import unsafeRunEff
  " function unsafeRunEff(f) {\
  \   return f();\
  \ } " :: forall e a. Eff e a -> a
