module CustomWords where

import Data.List.Split

charWords :: Char -> String -> [String]
charWords _ [] = []
charWords c xs = split (dropFinalBlank . dropInitBlank . keepDelimsL  $ oneOf [c]) xs

teststring = "-s ---d    descrizione del link   -D mtg  -rm"

firstWhiteSpace :: String -> [String]
firstWhiteSpace [] = []
firstWhiteSpace st = [takeWhile (/= ' ') st, dropWhile (/= ' ') st]

removeFirstWhite :: String -> String
removeFirstWhite [] = []
removeFirstWhite s = dropWhile (==' ') s

removeLastWhite :: String -> String
removeLastWhite [] = []
removeLastWhite s
  | last s == ' ' = init s
  | otherwise = s

nonEmpty :: String -> Bool
nonEmpty [] = False
nonEmpty str = foldr ((||) . (/=' ')) False str

customWords :: String -> [String]
customWords z = fmap removeFirstWhite $ fmap removeLastWhite $ filter (\x -> x/= "" && nonEmpty x == True) $ concat $ fmap firstWhiteSpace $  charWords '-' z
