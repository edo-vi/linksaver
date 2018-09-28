module CustomWords where

import Data.List.Split

charWords :: Char -> String -> [String]
charWords _ [] = []
charWords c xs = split (dropFinalBlank . dropInitBlank . keepDelimsL  $ oneOf [c]) xs

firstWhiteSpace :: String -> [String]
firstWhiteSpace [] = []
firstWhiteSpace st = [takeWhile (/= ' ') st, dropWhile (/= ' ') st]

trim :: String -> String
trim = removeInitWhites . removeTrailingWhites

removeInitWhites :: String -> String
removeInitWhites [] = []
removeInitWhites s = dropWhile (== ' ') s

removeTrailingWhites :: String -> String
removeTrailingWhites [] = []
removeTrailingWhites s = reverse . removeInitWhites . reverse $ s

nonEmpty :: String -> Bool
nonEmpty [] = False
nonEmpty str = foldr ((||) . (/=' ')) False str

customWords :: String -> [String]
customWords z = fmap trim $ filter (\x -> x/= "" && nonEmpty x == True) 
                $ concat $ fmap firstWhiteSpace $  charWords '-' z
