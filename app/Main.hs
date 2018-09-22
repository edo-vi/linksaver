module Main where
import Command

-- | Haddock test
main :: IO ()
main = print $ parse "-d Hello, Haskell!"
