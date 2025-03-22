module Firebase where

import Prelude

import Affjax.ResponseFormat as AXRF
import Affjax.Web as AXWeb
import Data.Argonaut.Core (stringify)
import Data.Argonaut.Decode (decodeJson)
import Data.Argonaut.Decode.Error (printJsonDecodeError)
import Data.Either (Either(..))
import Data.Post (Post(..))
import Effect.Aff (Aff)
import Effect.Class.Console (log)
import Foreign.Object as FO
import Halogen as H

firebaseUrl :: String
firebaseUrl = "https://blogpost-database-default-rtdb.firebaseio.com/"

fetchPosts :: Aff (Either String (FO.Object Post))
fetchPosts = do
  result <- AXWeb.get AXRF.json $ firebaseUrl <> "/posts.json"
  case result of
    Left err -> pure $ Left $ AXWeb.printError err
    Right response -> case decodeJson response.body of
      Left err -> pure $ Left $ "JSON decode error: " <> printJsonDecodeError err
      Right posts -> pure $ Right posts

fetchPostById :: String -> Aff (Either String Post)
fetchPostById postId = do
  let url = firebaseUrl <> "/posts/" <> postId <> ".json"
  result <- AXWeb.get AXRF.json url
  case result of
    Left err -> pure $ Left $ AXWeb.printError err
    Right response -> do
      H.liftEffect $ log $ "Raw response for " <> postId <> ": " <> stringify response.body
      case decodeJson response.body of
        Left err -> pure $ Left $ "JSON decode error: " <> printJsonDecodeError err
        Right (Post post) -> pure $ Right $ Post (post { id = postId }) -- Inject postId
