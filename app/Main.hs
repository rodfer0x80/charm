import Control.Monad (unless, when)
import System.Directory (doesFileExist)
import System.Environment (getArgs)
import System.IO (IOMode (ReadMode), hGetContents, openFile)

getValidArgs :: IO [String]
getValidArgs = do
  args <- getArgs
  when (null args) $ error "Error: No arguments provided"
  return args

getValidFile :: String -> IO String
getValidFile filename = do
  fileExists <- doesFileExist filename
  unless fileExists $ error "Error: File does not exist"
  return filename

readFileContents :: String -> IO String
readFileContents filename = do
  file <- openFile filename ReadMode
  hGetContents file

main :: IO ()
main = getValidArgs >>= getValidFile . head >>= readFileContents >>= putStrLn
