{-# LANGUAGE OverloadedStrings #-}
module Main where

import Test.Hspec
import Main (parser, lexer)

main :: IO ()
main = hspec $ do
  describe "lexer" $ do
    it "tokenizes a simple C program" $ do
      let source = "int main() { return 42; }"
      let expectedTokens = [TInt, TMain, TOpenBrace, TReturn, TNumber 42, TSemicolon, TCloseBrace]
      runParser lexer "" source `shouldBe` Right expectedTokens

  describe "parser" $ do
    it "parses the tokens into an integer" $ do
      let tokens = [TInt, TMain, TOpenBrace, TReturn, TNumber 42, TSemicolon, TCloseBrace]
      parser tokens `shouldBe` Right 42

    it "handles invalid tokens" $ do
      let tokens = [TInt, TMain, TOpenBrace, TReturn, TNumber 42, TSemicolon]
      parser tokens `shouldBe` Left "Invalid tokens"

