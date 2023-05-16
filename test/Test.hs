{-# LANGUAGE GADTs #-}
{-# LANGUAGE DataKinds #-}
module Test where
import Control.Monad.State
data Nat = S Nat | Z
data Vec :: Nat -> * where
  Nil  :: Vec Z
  Cons :: Int -> Vec n -> Vec (S n)

