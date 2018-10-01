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
    case checkNumMainOptions com of
        0 -> fetchLinks conn
        1 -> case existsInCommand "s" com of
                  True  -> insertLink conn com
                  False -> case existsInCommand "rm" com of
                                True -> removeLinks conn com
                                False -> fetchLinks conn -- then we imply -r
        _ -> print ("You can use only one option between -r, -s, and -rm") 
             >> return ()


insertLink :: Connection -> Command -> IO() 
insertLink conn com = let justLink = value . fromJust $ getFromCommand "l" com
                          stringLink = fromJust justLink
                          justDesc = if isJust (getFromCommand "d" com) then value . fromJust $ getFromCommand "d" com else Nothing
                          stringDesc = if isJust justDesc then fromJust justDesc else ""
                       in if justLink == Nothing || stringLink == ""
                          then return ()
                          else do
                            execute conn "insert into creatures (link,description) values (?,?)"
                                (stringLink :: String, stringDesc :: String)
                            print ("Inserted link into database")

fetchLinks :: Connection -> IO()
fetchLinks conn = do 
                    i <- query_ conn "select * from creatures" -- [Link]
                    printLinks $ (i :: [Link])                            

removeLinks :: Connection -> Command -> IO()
removeLinks conn com = let _id = (read . fromJust . value . fromJust $ getFromCommand "id" com ) :: Integer
                        in do
                            rows <- query conn "select * from creatures where id=?" [_id :: Integer]
                            if length (rows :: [Link]) /= 0 
                                then (execute conn "delete from creatures where id=?" [_id :: Integer]) >> printDeleted (head rows)
                                else print ("Couldn't delete link with id " ++ show _id)

checkNumMainOptions :: Command -> Int
checkNumMainOptions (Command o) = length . filter (`elem` ["r","s","rm"]) . map option $ o 