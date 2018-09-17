module Command(Command, Option) where

data Option = Option { option :: String
                     , value :: String
                     }
                     deriving (Eq, Show)

newtype Command = Command [Option] deriving (Eq, Show) 

validOptions :: [String]
validOptions = ["d", "D", "u", "rm", "l"]

isValidOption :: Option -> Bool
isValidOption x = (option x) `elem` validOptions

isValidString :: String -> Bool
isValidString s = s `elem` validOptions

parse :: String -> [Option]
parse s = let y  = words s
              getO :: [String] -> [Option]
              getO []     = []
              getO [_]    = []
              getO [_,""] = []
              getO ["",_] = []
              getO (x:w:xs) = case first == '-' && isValidString second of
                                True  -> [Option {
                                    option = second, value = w
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