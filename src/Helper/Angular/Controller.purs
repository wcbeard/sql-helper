module Todomvc.Controller (todoctrl) where

-- import qualified Data.Array as A
-- import qualified Data.String as S
-- import Data.Foldable
-- import Data.Maybe
-- import Control.Monad (unless, when)
import Control.Monad.Eff (Eff())


-- import Control.Monad.ST (ST(), STArray(), newSTArray, runSTArray)

-- import Angular (copy, extend)
import Angular.Scope (Scope(), readScope, extendScope, modifyScope)
-- import Angular.Scope (Scope(), watch, readScope, extendScope, modifyScope)
-- import Angular.This(readThis, writeThis)
-- import Angular.ST (readSTArray, pushSTArray, pushAllSTArray, writeSTArray, spliceSTArray)


controller scope = do
  extendScope {newTodo: "hello?"} scope

foreign import todoctrl
  " /*@ngInject*/function todoctrl($scope) { \
  \   var impl = controller($scope); \
  \   return impl.apply(this, []); \
  \ } "
  :: forall e a. Scope a -> Eff e Unit
