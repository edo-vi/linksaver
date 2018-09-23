module Main where
import Command
import System.Environment (getArgs)


main :: IO ()
main = do
    cont <- getArgs
    print $ parseList cont
