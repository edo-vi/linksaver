module Fill where
import Command

defaultDatabase :: Option
defaultDatabase = Option "D" $ Just "mtg"

defaultTable :: Option
defaultTable = Option "t" $ Just "creatures"

defaultUsername :: Option
defaultUsername = Option "u" $ Just "postgres"

defaults :: [Option]
defaults = [defaultDatabase, defaultUsername, defaultTable]

fillDefaults :: [Option] -> Command -> Command
fillDefaults l (Command list) = let 
                                  fill :: [Option] -> [Option] -> [Option]
                                  fill _ [] = []
                                  fill o (s: ss)
                                    | existsOption (option s) o = [] ++ fill o ss
                                    | otherwise = s : fill o ss  
                              in Command (list ++ fill list l)

testCommand = Command [Option "D" (Just "non-mtg"), Option "rm" Nothing]