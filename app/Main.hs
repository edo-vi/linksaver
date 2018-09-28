{-# LANGUAGE OverloadedStrings #-}

module Main where
import Command
import Data.String
import System.Environment (getArgs)
import System.Hclip(getClipboard)
import Fill(defaultOptions)
import Builder
import Link
import Database.PostgreSQL.Simple
import Data.Maybe

main :: IO ()
main = do
    options <- getArgs -- IO [string] containing the options
    clip <- getClipboard
    com <- return $ buildCommand (Option "l" (Just clip) : defaultOptions) (parseList options)
    conn <- buildConnection com
    case existsInCommand "s" com of
        True  -> let justLink = value . fromJust $ getFromCommand "l" com
                     stringLink = fromJust justLink
                     justDesc = if isJust (getFromCommand "d" com) then value . fromJust $ getFromCommand "d" com else Nothing
                     stringDesc = if isJust justDesc then fromJust justDesc else ""
                  in if justLink == Nothing || stringLink == ""
                     then return ()
                     else do
                            execute conn "insert into creatures (link,description) values (?,?)"
                                (stringLink :: String, stringDesc :: String)
                            print ("Inserted link into database")
                  
        False -> do 
                  i <- query_ conn "select * from creatures" -- [Link]
                  printLinks $ (i :: [Link])

           
