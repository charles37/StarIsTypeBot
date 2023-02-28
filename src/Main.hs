{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}

import qualified Control.Monad.Trans.State.Strict as S
import qualified Data.ByteString.Char8 as BS
import qualified Data.Text as T
import qualified Data.Text.IO as T
import qualified Data.Text.Encoding as T
import qualified GitHub as GH
import qualified GitHub.Data.Name as GH
import qualified GitHub.Data.URL as GH
import qualified GitHub.Endpoints.Repos as GH
import qualified System.Directory as Dir
import qualified Turtle as TU
import Control.Monad.IO.Unlift
import Test.Framework.HUnitWrapper (assertEqual)



-- main :: IO ()
-- main = do
--   token <- BS.readFile "token.txt" -- your personal access token
--   let auth = GH.OAuth $ T.strip $ T.decodeUtf8 token
--   let m = S.evalStateT loop auth
--   res <- GH.executeRequest m
--   print res

-- loop :: S.StateT GH.Auth IO ()
-- loop = do
--   repos <- GH.searchReposR "language:haskell"
--   let repos' = take 10 $ GH.searchResultResults repos
--   mapM_ processRepo repos'

-- processRepo :: GH.Repo -> S.StateT GH.Auth IO ()
-- processRepo repo = do
--   let owner = GH.simpleOwnerLogin $ GH.repoOwner repo
--   let name = GH.repoName repo
--   let dir = T.unpack $ GH.untagName owner <> "/" <> GH.untagName name
--   TU.sh $ TU.mkdir $ TU.fromText $ T.pack dir
--   TU.cd $ TU.fromText $ T.pack dir
--   TU.procs "git" ["clone", T.unpack $ GH.getUrl $ GH.repoCloneUrl repo] TU.empty
--   TU.cd ".."
--   TU.cd $ TU.fromText $ T.pack dir
--   let foldFunc acc file = file:acc
--   files <- TU.fold (filter (TU.hasExtension ".hs") $ TU.ls ".") foldFunc []

--   -- files <- TU.fold (TU.ls TU..? TU.hasExtension ".hs") TU.list
--   mapM_ processFile files
--   TU.procs "git" ["commit", "-a", "-m", "Replace * with Type from Data.Kind"] TU.empty
--   TU.procs "git" ["push", "origin", "HEAD"] TU.empty
--   let newBranch = "replace-star-with-type"
--   let pullRequest = GH.CreatePullRequest "Replace * with Type from Data.Kind" (GH.RepoRef owner name) newBranch "master"
--   -- createPullRequestR :: Name Owner -> Name Repo -> CreatePullRequest -> Request 'RW PullRequest
--   GH.createPullRequestR owner name pullRequest

processFile :: TU.FilePath -> S.StateT GH.Auth IO ()
processFile file = do
  contents <- TU.liftIO $ TU.readTextFile file

  let theTuple = T.breakOnAll "where" contents -- split file into lines before and after the where keyword
  let linesBefore = fst theTuple
  let linesAfter = snd theTuple
  let linesBefore' = T.lines linesBefore
  let linesAfter' = T.lines $ T.drop 5 linesAfter -- drop the where keyword and the newline after it
  let (imports, lines') = span (\line -> "import" `T.isPrefixOf` line) linesBefore' -- find the import statements
  let hasStar = any (\line -> " :: " `T.isInfixOf` line && "*" `T.isInfixOf` line) lines' -- check if there are any type signatures that use *
  let imports' = if hasStar then imports ++ ["import qualified Data.Kind as DK"] else imports -- add the Data.Kind import if necessary
  let lines'' = map (T.replace "*" "DK.Type") lines' -- replace * with DK.Type
  let linesAfter'' = if hasStar then "where\n" : lines'' else lines'' -- add the where keyword if necessary
  let contents' = T.unlines $ imports' ++ linesBefore' ++ linesAfter'' -- combine the modified lines
  TU.liftIO $ TU.writeTextFile file contents'

 
processFileIO :: TU.FilePath -> IO ()
processFileIO file = do
  contents <- TU.readTextFile file
  let theTuple = T.breakOnAll "where" contents -- split file into lines before and after the where keyword
  let linesBefore = fst theTuple
  let linesAfter = snd theTuple
  let linesBefore' = T.lines linesBefore
  let linesAfter' = T.lines $ T.drop 5 linesAfter -- drop the where keyword and the newline after it
  let (imports, lines') = span (\line -> "import" `T.isPrefixOf` line) linesBefore' -- find the import statements
  let hasStar = any (\line -> " :: " `T.isInfixOf` line && "*" `T.isInfixOf` line) lines' -- check if there are any type signatures that use *
  let imports' = if hasStar then imports ++ ["import qualified Data.Kind as DK"] else imports -- add the Data.Kind import if necessary
  let lines'' = map (T.replace "*" "DK.Type") lines' -- replace * with DK.Type
  let linesAfter'' = if hasStar then "where\n" : lines'' else lines'' -- add the where keyword if necessary
  let contents' = T.unlines $ imports' ++ linesBefore' ++ linesAfter'' -- combine the modified lines
  TU.writeTextFile file contents'

-- testFile:

-- {-# LANGUAGE DataKinds #-}

-- module Test where

-- import Control.Monad.State
-- import Data.Kind

-- type MyType = Int -> * -> State Int ()

-- myFunc :: MyType
-- myFunc = undefined

testProcessFile :: IO ()
testProcessFile = do
  let file = TU.fromText "testFile"
  TU.writeTextFile file "import Control.Monad.State\n\nwhere\n\nmyFunc :: Int -> * -> State Int ()\nmyFunc = undefined"
  processFileIO file
  contents <- TU.readTextFile file
  let expected = "import Control.Monad.State\nimport qualified Data.Kind as DK\n\nwhere\n\nmyFunc :: Int -> DK.Type -> State Int ()\nmyFunc = undefined"
  assertEqual expected contents