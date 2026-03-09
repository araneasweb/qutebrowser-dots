{-# LANGUAGE GHC2021 #-}
{-# LANGUAGE BlockArguments #-}
{-# LANGUAGE ImportQualifiedPost #-}
{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE OverloadedStrings #-}

module Main (main) where

import Control.Exception (bracket)
import Control.Monad (unless)
import Data.Int (Int64)
import Data.Text (Text)
import Data.Text qualified as T
import Data.Text.IO qualified as T
import Database.SQLite.Simple (Only (..), close, open, query)
import System.Directory (
    createDirectoryIfMissing,
    doesFileExist,
    getHomeDirectory,
 )
import System.Environment (lookupEnv)
import System.Exit (die)
import System.FilePath ((</>))

generatedPrefix :: Text
generatedPrefix = "fq"

main :: IO ()
main = do
    configDir <- quteDir "QUTE_CONFIG_DIR" "XDG_CONFIG_HOME" ".config"
    dataDir <- quteDir "QUTE_DATA_DIR" "XDG_DATA_HOME" ".local/share"

    let quickmarks = configDir </> "quickmarks"
        historyDb = dataDir </> "history.sqlite"
        maxQuickmarks = 500 :: Int

    exists <- doesFileExist historyDb
    unless exists $
        die $
            "Missing qutebrowser history DB: " <> historyDb

    createDirectoryIfMissing True configDir

    existing <-
        doesFileExist quickmarks >>= \case
            True -> do
                T.lines <$> T.readFile quickmarks
            False ->
                pure []

    ranked <-
        bracket (open historyDb) close \db ->
            query
                db
                "SELECT url, COUNT(*) AS visits, MAX(atime) AS last_atime \
                \FROM History \
                \WHERE url <> '' \
                \GROUP BY url \
                \ORDER BY visits DESC, last_atime DESC \
                \LIMIT ?"
                (Only maxQuickmarks) ::
                IO [(Text, Int64, Int64)]

    let width = length . show $ maxQuickmarks
        generated =
            [ render width i url
            | (i, (url, _, _)) <- zip [1 :: Int ..] ranked
            ]

    T.writeFile quickmarks . T.unlines $
        filter (not . isGenerated) existing <> generated

    lookupEnv "QUTE_FIFO" >>= \case
        Just fifo -> appendFile fifo "restart\n"
        Nothing -> pure ()

quteDir :: String -> String -> FilePath -> IO FilePath
quteDir explicit xdg fallback =
    lookupEnv explicit >>= \case
        Just dir -> pure dir
        Nothing ->
            lookupEnv xdg >>= \case
                Just base -> pure (base </> "qutebrowser")
                Nothing -> (</> fallback </> "qutebrowser") <$> getHomeDirectory

isGenerated :: Text -> Bool
isGenerated line = case T.words line of
    name : _ -> generatedPrefix `T.isPrefixOf` name
    [] -> False

render :: Int -> Int -> Text -> Text
render width i url =
    generatedPrefix <> T.justifyRight width '0' (T.pack (show i)) <> " " <> url
