module Helper.Angular.Main where

import Angular.Module (controller, ngmodule')

import Todomvc.Controller (todoctrl)
import Debug.Trace

main = do
  trace "hi"
  m <- ngmodule' "todomvc" []
  controller "TodoCtrl" todoctrl m
