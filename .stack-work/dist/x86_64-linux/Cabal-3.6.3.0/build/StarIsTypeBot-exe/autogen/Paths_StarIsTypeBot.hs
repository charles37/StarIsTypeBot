{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -w #-}
module Paths_StarIsTypeBot (
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
version = Version [0,1,0,0] []

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir `joinFileName` name)

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath




bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath
bindir     = "/home/ben/StarIsTypeBot/.stack-work/install/x86_64-linux/6d2986f8a19654747a81f56b17b337dde8f68135f2aa5ac43f0d7228ea93985a/9.2.7/bin"
libdir     = "/home/ben/StarIsTypeBot/.stack-work/install/x86_64-linux/6d2986f8a19654747a81f56b17b337dde8f68135f2aa5ac43f0d7228ea93985a/9.2.7/lib/x86_64-linux-ghc-9.2.7/StarIsTypeBot-0.1.0.0-B43Naqn84nHJYEtw36pk5x-StarIsTypeBot-exe"
dynlibdir  = "/home/ben/StarIsTypeBot/.stack-work/install/x86_64-linux/6d2986f8a19654747a81f56b17b337dde8f68135f2aa5ac43f0d7228ea93985a/9.2.7/lib/x86_64-linux-ghc-9.2.7"
datadir    = "/home/ben/StarIsTypeBot/.stack-work/install/x86_64-linux/6d2986f8a19654747a81f56b17b337dde8f68135f2aa5ac43f0d7228ea93985a/9.2.7/share/x86_64-linux-ghc-9.2.7/StarIsTypeBot-0.1.0.0"
libexecdir = "/home/ben/StarIsTypeBot/.stack-work/install/x86_64-linux/6d2986f8a19654747a81f56b17b337dde8f68135f2aa5ac43f0d7228ea93985a/9.2.7/libexec/x86_64-linux-ghc-9.2.7/StarIsTypeBot-0.1.0.0"
sysconfdir = "/home/ben/StarIsTypeBot/.stack-work/install/x86_64-linux/6d2986f8a19654747a81f56b17b337dde8f68135f2aa5ac43f0d7228ea93985a/9.2.7/etc"

getBinDir     = catchIO (getEnv "StarIsTypeBot_bindir")     (\_ -> return bindir)
getLibDir     = catchIO (getEnv "StarIsTypeBot_libdir")     (\_ -> return libdir)
getDynLibDir  = catchIO (getEnv "StarIsTypeBot_dynlibdir")  (\_ -> return dynlibdir)
getDataDir    = catchIO (getEnv "StarIsTypeBot_datadir")    (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "StarIsTypeBot_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "StarIsTypeBot_sysconfdir") (\_ -> return sysconfdir)



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
