{-# LANGUAGE OverloadedStrings #-}

module Main where
import Command
import Data.String
import System.Environment (getArgs)
import System.Hclip(getClipboard)
import Fill(defaultOptions)
import Builder(buildCommand)
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.FromRow
import Database.PostgreSQL.Simple.Types

{- 
main :: IO ()
main = do
    getArgs >>= -- IO [string] containing the options
        (\options -> getClipboard >>=
            \clip -> print $ buildCommand (Option "l" (Just clip) : defaultOptions) (parseList options))
-}

main :: IO ()
main = do
    options <- getArgs -- IO [string] containing the options
    clip <- getClipboard
    com <- return $ buildCommand (Option "l" (Just clip) : defaultOptions) (parseList options)
    conn <- connect $ ConnectInfo "localhost" 5432 "postgres" "" "mtg" 
    i <- query_ conn "select * from creatures" -- [Link]
    printLinks $ (i :: [Link])

printLinks :: [Link] -> IO ()
printLinks [] = return ()
printLinks (x:xs) = putStr ("│  id    │ ") 
                    >> print(_id x) >> putStr ("│  link  │ ")
                       >> putStrLn (link x) >> putStr ("│  desc  │ ") 
                          >> putStrLn (description x) >> putStrLn("├────────────────────────────────────────")
                             >> printLinks xs

data Link = Link {
    _id :: Integer,
    link :: [Char],
    description :: [Char]
} deriving (Eq)

instance FromRow Link where
    fromRow = Link <$> field <*> field <*> field