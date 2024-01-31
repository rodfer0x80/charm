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

type Parser = Parsec Void String

rstrip :: String -> String
rstrip = reverse . dropWhile (== '\n') . reverse

assembly :: String -> String
assembly retval = rstrip $ unlines
    [ ".global main"
    , "main:"
    , "  mov w0, " ++ retval
    , "  ret"
    ]

cSourceParser :: Parser String
cSourceParser = do
    try $ string "int" >> space >> string "main()" >> space >> char '{'
    space  -- Consume any remaining whitespace
    string "return"
    space
    retval <- some digitChar  -- Use digitChar here
    space
    char ';'
    space  -- Consume any remaining whitespace
    char '}'
    many spaceChar  -- Skip any trailing whitespace or newlines
    eof
    return retval

main = do
    args <- getArgs
    case args of
        [sourceFile] -> do
            let assemblyFile = takeBaseName sourceFile ++ ".s"
            source <- readFile sourceFile
            case runParser cSourceParser "" source of
                Left err -> putStrLn $ "Error parsing C source: " ++ show err
                Right retval -> withFile assemblyFile WriteMode $ \outfile -> do
                    hPutStrLn outfile $ assembly retval
        _ -> putStrLn "Usage: ./program <source_file>"

