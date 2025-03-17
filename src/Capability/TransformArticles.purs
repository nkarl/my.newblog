module Capability.TransformArticles where

import Prelude

import Effect (Effect)
import Effect.Aff (Aff)
import Promise (Promise)
import Promise.Aff as PromiseAff

foreign import convertMarkdownImpl
  :: String -> Effect (Promise String)

convertMarkdown :: String -> Aff (String)
convertMarkdown = convertMarkdownImpl >>> PromiseAff.toAffE
