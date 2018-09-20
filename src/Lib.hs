
module Lib where


type Input = String

-- | Possible state of the deterministic Parser finite automata.
data ParserState = WaitingOption | WaitingValue | End deriving (Eq, Show)

-- | Product data type representing a parser taking a string as input. 
-- It is implemented as a finite automata so
--it also contains information about its current state.
data Parser = Parser ParserState deriving (Eq, Show)

-- | Option that can be parsed and used to construct a command. Contains two field:
-- /option/, which is the string symbol used as identifier, and its /value/, another string
-- (possibily Nothing).
data Option = Option { option :: String
                     , value :: Maybe String
                     }
                     deriving (Eq, Show)

-- | A command constructed by Options.
newtype Command = Command [Option] deriving (Eq, Show) 

transition :: String -> Parser -> Parser
transition ('-':xs) (Parser WaitingOption)
  | isValidString xs = Parser WaitingValue
  | otherwise = Parser WaitingOption
transition _ (Parser WaitingValue) = Parser WaitingOption
transition _ (Parser WaitingOption) = Parser WaitingOption
-- TODO adds remaining matches

validOptions :: [String]
validOptions = ["d", "D", "u", "rm", "l"]

isValidOption :: Option -> Bool
isValidOption x = option x `elem` validOptions

isValidString :: String -> Bool
isValidString s = s `elem` validOptions

parse :: String -> [Option]
parse s = let y  = words s
              getO :: [String] -> [Option]
              getO []     = []
              getO [_]    = []
              getO [_,""] = []
              getO ["",_] = []
              getO (x:w:xs) = case first == '-' && isValidString second && head w /= '-' of
                                True  -> [Option {
                                    option = second, value = Just w
                                    }] ++ getO xs
                                False -> getO (w:xs)
                                where first = head x
                                      second = tail x
          in getO y

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