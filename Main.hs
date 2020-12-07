{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE LambdaCase #-}

module Main where

import           Prelude
import qualified Prelude                 as P  ( head )
import           Control.Monad.IO.Class
import qualified Data.Text               as T
import           System.Environment            ( lookupEnv )
import           Text.Read                     ( readMaybe )
import           Data.Maybe                    ( fromMaybe )

import           Network.HTTP.Types.Status ( status404 )
import           Web.Spock
import           Web.Spock.Config

type Server = SpockM () () () ()

main :: IO ()
main = do
  spockCfg <- defaultSpockCfg () PCNoDatabase ()
  port <- (=<<) readMaybe <$> lookupEnv "PICOURL_PORT"
  runSpock (fromMaybe 8080 port) (spock spockCfg app)

app :: Server
app = do
  get var $ \key -> do
    (lookup key <$> liftIO parseRoutes) >>= \case
      Nothing -> setStatus status404 *> text "Not found"
      (Just s) -> redirect $ T.pack s

parseRoutes :: IO [(String, String)]
parseRoutes = map ((\[a,b] -> (a,b)) . words)
                . filter ((/= '#') . P.head)
                . filter (not . null)
                . lines
                <$> readFile "routes"
