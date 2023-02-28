{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -w #-}
module Paths_starIsTypeBot (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where


import qualified Control.Exception as Exception
import qualified Data.List as List
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude


#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,0,0] []

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir `joinFileName` name)

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath



bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath
bindir     = "/home/ben/personal/StarIsTypeBot/.stack-work/install/x86_64-linux-tinfo6/e82ae8ff712f61077daf4bb7286ebfecad18aad0549a6e535dc36a2b6269d3dd/9.2.6/bin"
libdir     = "/home/ben/personal/StarIsTypeBot/.stack-work/install/x86_64-linux-tinfo6/e82ae8ff712f61077daf4bb7286ebfecad18aad0549a6e535dc36a2b6269d3dd/9.2.6/lib/x86_64-linux-ghc-9.2.6/starIsTypeBot-0.0.0-DV5NWWnjJ8GKjmJQyggP8z"
dynlibdir  = "/home/ben/personal/StarIsTypeBot/.stack-work/install/x86_64-linux-tinfo6/e82ae8ff712f61077daf4bb7286ebfecad18aad0549a6e535dc36a2b6269d3dd/9.2.6/lib/x86_64-linux-ghc-9.2.6"
datadir    = "/home/ben/personal/StarIsTypeBot/.stack-work/install/x86_64-linux-tinfo6/e82ae8ff712f61077daf4bb7286ebfecad18aad0549a6e535dc36a2b6269d3dd/9.2.6/share/x86_64-linux-ghc-9.2.6/starIsTypeBot-0.0.0"
libexecdir = "/home/ben/personal/StarIsTypeBot/.stack-work/install/x86_64-linux-tinfo6/e82ae8ff712f61077daf4bb7286ebfecad18aad0549a6e535dc36a2b6269d3dd/9.2.6/libexec/x86_64-linux-ghc-9.2.6/starIsTypeBot-0.0.0"
sysconfdir = "/home/ben/personal/StarIsTypeBot/.stack-work/install/x86_64-linux-tinfo6/e82ae8ff712f61077daf4bb7286ebfecad18aad0549a6e535dc36a2b6269d3dd/9.2.6/etc"

getBinDir     = catchIO (getEnv "starIsTypeBot_bindir")     (\_ -> return bindir)
getLibDir     = catchIO (getEnv "starIsTypeBot_libdir")     (\_ -> return libdir)
getDynLibDir  = catchIO (getEnv "starIsTypeBot_dynlibdir")  (\_ -> return dynlibdir)
getDataDir    = catchIO (getEnv "starIsTypeBot_datadir")    (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "starIsTypeBot_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "starIsTypeBot_sysconfdir") (\_ -> return sysconfdir)




joinFileName :: String -> String -> FilePath
joinFileName ""  fname = fname
joinFileName "." fname = fname
joinFileName dir ""    = dir
joinFileName dir fname
  | isPathSeparator (List.last dir) = dir ++ fname
  | otherwise                       = dir ++ pathSeparator : fname

pathSeparator :: Char
pathSeparator = '/'

isPathSeparator :: Char -> Bool
isPathSeparator c = c == '/'
