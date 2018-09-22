
module Lib where

import Data.Maybe

type Input = String

-- | Tree structure.
data Tree a = Leaf | Node (Tree a) a (Tree a) deriving (Eq, Show)

-- | Parses the given string and creates a Tree whose right nodes are commands and 
-- left nodes are their values
parseToTree :: String -> Tree (Maybe String)
parseToTree s = let ws = words s
                    parTr :: [String] -> Tree (Maybe String) 
                    parTr [] = Leaf
                    parTr ([]:_) = Leaf
                    parTr [('-':xs)] = Node (Node Leaf Nothing Leaf) (Just xs) Leaf
                    parTr (('-':xs):n@('-':_):rest) 
                      | isValidString xs = Node (Node Leaf Nothing Leaf) (Just xs) (parTr (n:rest))
                      | otherwise = parTr (n:rest)
                    parTr (('-':xs):y:rest)
                      | isValidString xs = Node (Node Leaf (Just y) Leaf) (Just xs) (parTr rest) 
                      | otherwise = parTr (y:rest)
                    parTr (_:rest) = parTr rest -- this case only when we get two or more consecutive values,
                                                -- which are not valid
                in parTr ws

-- | Parses a Tree of Just String to an array of options
parseTreeToOptions :: Tree (Maybe String) -> [Option]
parseTreeToOptions Leaf = []
parseTreeToOptions (Node Leaf _ _) = []
parseTreeToOptions (Node (Node _ val _) val' r') = Option (fromJust val') val : parseTreeToOptions r'

-- | Option that can be parsed and used to construct a command. Contains two field:
-- /option/, which is the string symbol used as identifier, and its /value/, another string
-- (possibily Nothing).
data Option = Option { option :: String
                     , value :: Maybe String
                     }
                     deriving (Eq, Show)

-- | A command constructed by Options.
newtype Command = Command [Option] deriving (Eq, Show) 

-- | List of all valid options.
validOptions :: [String]
validOptions = ["d", "D", "u", "rm", "l"]


isValidOption :: Option -> Bool
isValidOption x = option x `elem` validOptions

isValidString :: String -> Bool
isValidString s = s `elem` validOptions

parse :: String -> [Option]
parse = parseTreeToOptions . parseToTree

cleanOption :: String -> String
cleanOption [] = []
cleanOption t@(x:xs) = if x=='-' then xs else t

existsOption :: String -> Command -> Bool
existsOption s (Command c)  = elem cleans (map (\x -> option x) c)
                              where cleans = cleanOption s

getOption :: String -> Command -> Maybe Option
getOption [] _ = Nothing
getOption s c 
  | existsOption s c == True = Just $ head (filter (\x -> option x == cleans) list)
  | otherwise                = Nothing 
  where list = (\(Command w) -> w) c
        cleans = cleanOption s

teststring = "-D mtg -d cute -u edo -w whatever"

test = parse teststring

command = Command (parse teststring)