#!/usr/bin/env runhaskell
\begin{code}

import WRP.CSS
import System.IO
import System.Environment
import System.Console.GetOpt
import System.Exit
import Data.Maybe ( fromMaybe )

data Options_Mode = Decompile
                  | Compile
                  | Decompile_Compile
                    deriving (Eq, Show)

data Options = Help
             | Version
             | Mode Options_Mode
             | Outfile   String
               deriving Show

name :: String
name = "cinnamonroll"

version_number :: String
version_number = "0.99.0"

header :: String
header = "Usage: " ++ name ++ " -[d|c|r] FILE"

options :: [OptDescr Options]
options =
  [ Option ['h'    ] ["help"     ] (NoArg Help     ) "display this help."
  , Option ['V','v'] ["version"  ] (NoArg Version  ) "show version number."
  , Option ['d'    ] ["decompile"] (NoArg (Mode Decompile)) "decompile; .cinnamonroll <== .css"
  , Option ['c'    ] ["compile"  ] (NoArg (Mode Compile  )) "compile  ; .cinnamonroll ==> .css"
  , Option ['r'    ] ["decompile-compile","reform"] (NoArg (Mode Decompile_Compile )) "reform   ; .css -----------> .css"
  ]

get_options :: IO ([Options], [String])
get_options = do
  a <- getArgs
  case getOpt Permute options a of
    (o, n , []  )  -> return (o, n)
    (_, _ , errs)  -> ioError ( userError ( concat errs ++ usage ) )

usage :: String
usage = usageInfo header options

main :: IO()
main = do
  (o, n) <- get_options
  
  m      <- case head $ reverse o of
    Mode a -> do
      v <- case n of
        [] -> getContents
        _  -> readFile $ head n
      case a of
        Decompile_Compile -> case decompile v of
          Right a -> return $ compile a
          Left  a -> return $ Left a
        Decompile         -> return $ decompile v
        Compile           -> return $ compile   v
    Version -> (putStrLn $ name ++ " " ++ version_number)                    >> exitSuccess
    _       -> (putStrLn $ name ++ " " ++ version_number ++ "\n\n" ++ usage) >> exitSuccess
  
  case m of
    Right a -> putStr a
    Left  a -> hPrint stderr a
  
  {--
  v <- getContents
  case decompile v of
    Right a -> putStr a
    Left  a -> hPrint stderr a
  --}

\end{code}
