module Data.Firebase where

import Prelude

import Affjax as AX
import Affjax.ResponseFormat as AXRF
import Control.Monad.Except (runExcept)
import Data.Bifunctor (lmap)
import Data.Either (Either(..), hush)
import Data.HTTP.Method (Method(..))
import Data.Maybe (Maybe(..))
import Data.Post (Post)
import Effect.Aff (Aff)
import Foreign.Object as FO

import Data.Argonaut.Core (Json)
import Data.Argonaut as Argonaut
import Data.Argonaut.Decode (class DecodeJson, decodeJson, (.:), (.:?))
import Data.Argonaut.Decode.Combinators (defaultField)
import Data.Argonaut.Decode.Decoders (decodeForeignObject, decodeJObject)

derive instance Generic Post _

firebaseUrl :: String
firebaseUrl = "https://blogpost-database-default-rtdb.firebaseio.com/posts.json"

fetchPosts :: Aff (Either String Post)
fetchPosts = do
  result <- AX.request
    ( AX.defaultRequest
        { url = firebaseUrl
        , method = Left GET
        , responseFormat = AXRF.json
        }
    )
  case result of
    Left err -> pure $ Left $ AX.printError err
    Right response -> do
      let decoded = decodePost response
      pure decoded

-- TODO: switch to using Argonaut to decode JSON strings
-- https://book.purescript.org/chapter10.html
decodePost :: Json -> Either String Post
decodePost json = do
  jsonString <- lmap ("No String in local storage: " <> _) $ Argonaut.decodeJson json
  jsonPost <- Argonaut.jsonParser jsonString
  pure ?_
