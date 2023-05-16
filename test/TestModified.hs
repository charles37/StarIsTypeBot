{-# LANGUAGE GADTs #-}
{-# LANGUAGE DataKinds #-}
module Test where

import Control.Monad.State
import Data.Kind (Type)

data Nat = S Nat | Z

data Vec :: Nat -> Type where
  Nil  :: Vec Z
  Cons :: Int -> Vec n -> Vec (S n)
