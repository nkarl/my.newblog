module Capability.TransformArticles where

import Prelude

import Effect (Effect)
import Effect.Aff (Aff)
import Promise (Promise)
import Promise.Aff as PromiseAff

foreign import transformMarkdownImpl
  :: String -> Effect (Promise String)

transformMarkdown :: String -> Aff (String)
transformMarkdown = transformMarkdownImpl >>> PromiseAff.toAffE
