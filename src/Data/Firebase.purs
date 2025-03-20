module Firebase where

import Prelude
import Affjax.Web as AXWeb
import Affjax.ResponseFormat as AXRF
import Data.Either (Either(..))
import Effect.Aff (Aff)
import Foreign.Object as FO
import Data.Post (Post)

import Data.Argonaut.Decode (decodeJson)
import Data.Argonaut.Decode.Error (printJsonDecodeError)

firebaseUrl :: String
firebaseUrl = "https://blogpost-database-default-rtdb.firebaseio.com/posts.json"

fetchPosts :: Aff (Either String (FO.Object Post))
fetchPosts = do
  result <- AXWeb.get AXRF.json firebaseUrl
  case result of
    Left err -> pure $ Left $ AXWeb.printError err
    Right response -> case decodeJson response.body of
      Left err -> pure $ Left $ "JSON decode error: " <> printJsonDecodeError err
      Right posts -> pure $ Right posts

fetchPost :: String -> Aff (Either String Post)
fetchPost postId = do
  result <- AXWeb.get AXRF.json (firebaseUrl <> "/" <> postId <> ".json")
  case result of
    Left err -> pure $ Left $ AXWeb.printError err
    Right response -> case decodeJson response.body of
      Left err -> pure $ Left $ "JSON decode error: " <> printJsonDecodeError err
      Right post -> pure $ Right post
