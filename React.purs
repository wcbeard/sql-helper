module Helper.React where

import React
import qualified React.DOM as D
import Debug.Trace

foreign import showing
 "function showing(x) {\
  \  console.log(x);\
  \}" :: forall a. a -> a

hello = mkUI spec do
  props <- getProps
  let x = showing props
  return $ D.h1 [
      D.className "Hello"
    ] [
      D.text "Hello, ",
      D.text props.name
    ]

incrementCounter e = do
  val <- readState
  -- let x = showing val
  writeState (val + 1)

-- x = show helloInConsole
incrementCounter' s = s

helloInConsole e = do
  props <- getProps
  trace ("Hello, " ++ props.name ++ "!")

counter = mkUI spec { getInitialState = return 0 } do
  val <- readState
  let x = showing val
  return $ D.p [
      D.className "Counter"
      , D.onClick incrementCounter
      , D.onClick helloInConsole
    ] [
      D.text (show val),
      D.text " Click me to increment!"
    ]

main = do
  let component = D.div [] [hello {name: "World"}, counter {count: 2}]
  renderToBody component
