{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE LambdaCase #-}

module Main where

import  Control.Monad.IO.Class
import  Data.Text               ( pack      )
import  System.Environment      ( lookupEnv )
import  Text.Read               ( readMaybe )
import  Data.Maybe              ( fromMaybe )

import  Network.HTTP.Types.Status ( status404 )
import  Web.Spock hiding ( head )
import  Web.Spock.Config

main :: IO ()
main = do
  spockCfg <- defaultSpockCfg () PCNoDatabase ()
  port <- (=<<) readMaybe <$> lookupEnv "PICOURL_PORT"
  runSpock (fromMaybe 8080 port) (spock spockCfg app)

app :: SpockM () () () ()
app = do
  get var $ \key ->
    (lookup key <$> liftIO parseRoutes) >>= \case
      Nothing  -> setStatus status404 *> text "Not found"
      (Just s) -> redirect $ pack s

parseRoutes :: IO [(String, String)]
parseRoutes = map ((\[a,b] -> (a,b)) . words)
                . filter ((/= '#') . head)
                . filter (not . null)
                . lines
                <$> readFile "routes"
