module Data.Firebase where

import Prelude

import Affjax.ResponseFormat as AXRF
import Affjax.Web as AXWeb
import Data.Argonaut.Decode (decodeJson)
import Data.Argonaut.Decode.Error (printJsonDecodeError)
import Data.Either (Either(..))
import Data.PostData (PostData(..))
import Effect.Aff (Aff)
import Foreign.Object as FO

-- | the default database location.
firebaseUrl :: String
firebaseUrl = "https://blogpost-database-default-rtdb.firebaseio.com"

-- | fetch all posts from Firebase.
fetchPosts :: Aff (Either String (FO.Object PostData))
fetchPosts = do
  result <- AXWeb.get AXRF.json $ firebaseUrl <> "/posts.json"
  case result of
    Left err -> pure $ Left $ AXWeb.printError err
    Right response -> case decodeJson response.body of
      Left err -> pure $ Left $ "JSON decode error: " <> printJsonDecodeError err
      Right posts -> pure $ Right posts

-- | given a postId, fetch a single post from Firebase
fetchPostById :: String -> Aff (Either String PostData)
fetchPostById postId = do
  result <- AXWeb.get AXRF.json $ firebaseUrl <> "/posts/" <> postId <> ".json"
  case result of
    Left err -> pure $ Left $ AXWeb.printError err
    Right response ->
      case decodeJson response.body of
      --H.liftEffect $ log $ "Raw response for " <> postId <> ": " <> stringify response.body
        Left err -> pure $ Left $ "JSON decode error: " <> printJsonDecodeError err
        Right (PostData post) -> pure $ Right $ PostData (post { id = postId }) -- Inject postId
