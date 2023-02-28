{-# LANGUAGE DataKinds #-}

module Test where

import Control.Monad.State
import Data.Kind

type MyType = Int -> * -> State Int ()

myFunc :: MyType
myFunc = undefined
