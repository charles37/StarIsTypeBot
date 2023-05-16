{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE ViewPatterns #-}
module StarIsTypeBot where

import Control.Monad
import Data.Data
import Data.Generics.Uniplate.Data
import Language.Haskell.Exts

transformStar :: Module SrcSpanInfo -> Module SrcSpanInfo
transformStar = transformBi replaceStar

replaceStar :: Type SrcSpanInfo -> Type SrcSpanInfo
replaceStar (TyCon _ (UnQual _ (Symbol _ "*"))) = TyCon noInfo (UnQual noInfo (Ident noInfo "Type"))
replaceStar ty = ty

noInfo :: SrcSpanInfo
noInfo = SrcSpanInfo noSpan []

noSpan :: SrcSpan
noSpan = SrcSpan "" 0 0 0 0

