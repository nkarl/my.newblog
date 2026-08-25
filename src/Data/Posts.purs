module Data.Posts where

import Prelude

import Affjax.ResponseFormat as AXRF
import Affjax.Web as AXWeb
import Data.Argonaut.Decode (decodeJson)
import Data.Argonaut.Decode.Error (printJsonDecodeError)
import Data.Either (Either(..))
import Data.Maybe (maybe)
import Data.PostData (PostData)
import Effect.Aff (Aff)
import Foreign.Object as FO

postsUrl :: String
postsUrl = "/posts.json"

fetchPosts :: Aff (Either String (FO.Object PostData))
fetchPosts = do
  result <- AXWeb.get AXRF.json postsUrl
  pure case result of
    Left err -> Left $ AXWeb.printError err
    Right response -> case decodeJson response.body of
      Left err -> Left $ "JSON decode error: " <> printJsonDecodeError err
      Right posts -> Right posts

fetchPostById :: String -> Aff (Either String PostData)
fetchPostById postId = do
  result <- fetchPosts
  pure case result of
    Left err -> Left err
    Right posts -> maybe
      (Left $ "Post not found: " <> postId)
      Right
      (FO.lookup postId posts)
