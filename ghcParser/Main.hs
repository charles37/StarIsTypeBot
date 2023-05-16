module Main where

import GHC
import GHC.Paths ( libdir )
import GHC.Parser
import GHC.Hs
import GHC.Utils.Outputable
import GHC.Driver.Session
import GHC.Data.StringBuffer
import GHC.Types.SrcLoc
import GHC.Unit.Finder
import GHC.Driver.Ppr

import System.Environment

main :: IO ()
main = do
    -- Get the path of the file from the command line arguments.
    (filepath:_) <- getArgs

    -- Parse the Haskell file.
    runGhc (Just libdir) $ do
        dflags <- getSessionDynFlags
        setSessionDynFlags dflags
        target <- guessTarget filepath Nothing
        addTarget target
        load LoadAllTargets

        modSum <- getModSummary =<< findModule (mkModuleName "Test") Nothing
        p <- parseModule modSum

        -- Print the AST.
        liftIO $ putStrLn $ showSDocUnsafe $ ppr $ unLoc $ pm_parsed_source p

