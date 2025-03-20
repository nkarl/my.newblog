module Data.Post where

import Prelude

import Data.Argonaut.Decode (class DecodeJson, decodeJson, (.:), (.:?))
import Data.Maybe (Maybe(..))

newtype Post = Post
  { content :: String
  , createdAt :: Number
  , description :: String
  , id :: String
  , pubDate :: Maybe String
  , title :: String
  , type :: Maybe String
  }

derive instance eqPost :: Eq Post

instance decodeJsonPost :: DecodeJson Post where
  decodeJson json = do
    obj <- decodeJson json
    id <- obj .: "id"
    content <- obj .: "content"
    title <- obj .: "title"
    description <- obj .:? "description"
    pubDate <- obj .:? "pubDate"
    type_ <- obj .:? "type"
    createdAt <- obj .: "createdAt"
    pure
      $ Post
          { id
          , content
          , title
          , description: maybe "" identity description
          , pubDate
          , type: type_
          , createdAt
          }

-- Helper for defaulting optional fields
maybe :: forall a. a -> (String -> a) -> Maybe String -> a
maybe default f maybeStr = case maybeStr of
  Nothing -> default
  Just str -> f str
