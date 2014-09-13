module Todomvc.Controller (todoctrl) where

import Control.Monad.Eff (Eff())
import Helper ((..), prefix, combine, toFloat)
import Debug.Trace (trace)
import Data.Array (snoc)
import Angular.Scope (Scope(), extendScope, modifyScope, ReadWriteEff(), WriteEff(..))


controller :: forall a b. Scope (selects :: [{  }] | a) -> WriteEff b
controller scope = do
  extendScope {newTodo: "hello?"
              , trace: printer
              , prefix: prefix
              , combine: combine
              , showScope: (\_ -> printer scope)
              , transforms: {float: toFloat, none: (\a->a)}
              , selects: [{}]
              , increment: increment scope
              } scope

increment :: forall a b. Scope (selects :: [{  }] | a) -> ReadWriteEff b Unit
increment scope = modifyScope (\s -> do
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

foreign import printer
"function printer(a){\
\ console.log(a); \
\ }" :: forall a. a -> a
