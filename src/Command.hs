module Command(Command, Option) where

data Option = Option { option :: String
                     , value :: String
                     }
                     deriving (Eq, Show)

newtype Command = Command [Option] deriving (Eq, Show) 

validOptions :: [String]
validOptions = ["d", "D", "u", "rm", "l"]

isValidOption :: Option -> Bool
isValidOption x = elem (option x) validOptions

isValidString :: String -> Bool
isValidString s = elem s validOptions

parse :: String -> [Option]
parse s = let y  = words s
              getO :: [String] -> [Option]
              getO []     = []
              getO [_]    = []
              getO [_,""] = []
              getO ["",_] = []
              getO (x:y:xs) = case first == '-' && isValidString second of
                                True  -> [Option {
                                    option = second, value = y
                                    }] ++ getO xs
                                False -> [] ++ getO (y:xs)
                                where first = x !! 0
                                      second = tail x
          in getO y

existsOption :: String -> Command -> Bool
existsOption s (Command c) 
  | s !! 0 == '-' = elem (tail s) (map (\x -> option x) c)
  | otherwise = elem s (map (\x -> option x) c)
                              
teststring = "-D mtg -d cute -u edo"