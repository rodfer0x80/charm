{-# LANGUAGE OverloadedStrings #-}

import Control.Monad.Except
import System.FilePath (takeBaseName)
import System.IO (withFile, IOMode(WriteMode), hPutStrLn)
import System.Environment (getArgs)
import Data.Text (pack, intercalate) 
import Text.Megaparsec
import Text.Megaparsec.Char
import Text.Megaparsec.Error
import Data.Void (Void)
import Text.Megaparsec.Char.Lexer (decimal)
import qualified Text.Megaparsec as Megaparsec

rstrip :: String -> String
rstrip = reverse . dropWhile (== '\n') . reverse

type Parser = Parsec Void String

data CToken = TInt | TMain | TOpenBrace | TCloseBrace | TReturn | TNumber Int | TSemicolon
    deriving (Show, Eq)

lexer :: Parser [CToken]
lexer = many (lex token) <* eof
  where
    lex = (<* space)
    token = choice
      [ TInt <$ string "int"
      , TMain <$ string "main()"
      , TOpenBrace <$ char '{'
      , TCloseBrace <$ char '}'
      , TReturn <$ string "return"
      , TNumber <$> lex decimal
      , TSemicolon <$ char ';'
      ]

parser :: [CToken] -> Either String Int
parser tokens = case tokens of
    [TInt, TMain, TOpenBrace, TReturn, TNumber n, TSemicolon, TCloseBrace] -> Right n
    _ -> Left "Invalid tokens"

codegen :: String -> String
codegen retval = rstrip $ unlines
    [ ".global main"
    , "main:"
    , "  mov w0, " ++ retval
    , "  ret"
    ]

main = do
    args <- getArgs
    case args of
        [sourceFile] -> do
            let assemblyFile = takeBaseName sourceFile ++ ".s"
            source <- readFile sourceFile
            case runParser lexer "" source of
                Left err -> putStrLn $ "Error lexing C source: " ++ show err
                Right tokens -> do
                    putStrLn $ "Tokens: " ++ show tokens
                    case parser tokens of
                        Left err -> putStrLn $ "Error parsing tokens: " ++ err
                        Right retval -> withFile assemblyFile WriteMode $ \outfile -> do
                            hPutStrLn outfile $ codegen $ show retval
        _ -> putStrLn "Usage: ./program <source_file>"

