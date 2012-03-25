#!/usr/bin/env runhaskell
\begin{code}
import WRP.CSS
import System.IO

main :: IO()
main = do
  v <- getContents
  case decompile v of
    Right a -> putStr a
    Left  a -> hPrint stderr a

\end{code}
