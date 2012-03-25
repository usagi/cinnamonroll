#!/usr/bin/env runhaskell
\begin{code}

import WRP.CSS
import System.IO

main :: IO()
main = do
  v <- getContents
  case parseCSS v of
    Right a -> hPrint stderr a
    Left  a -> hPrint stderr a
    
\end{code}
