module Fill where
import Command

defaultDatabase :: Option
defaultDatabase = Option "D" $ Just "mtg"

defaultTable :: Option
defaultTable = Option "t" $ Just "creatures"

defaultUsername :: Option
defaultUsername = Option "u" $ Just "postgres"

defaultOptions :: [Option]
defaultOptions = [defaultDatabase, defaultUsername, defaultTable]

fillDefaultsCommand :: [Option] -> Command -> Command
fillDefaultsCommand l (Command list) = let 
                                  fill :: [Option] -> [Option] -> [Option]
                                  fill _ [] = []
                                  fill o (s: ss)
                                    | existsOption (option s) o = [] ++ fill o ss
                                    | otherwise = s : fill o ss  
                              in Command (list ++ fill list l)


fillDefaults :: [Option] -> [Option] -> [Option]
fillDefaults def list = let 
                              fill :: [Option] -> [Option] -> [Option]
                              fill _ [] = []
                              fill o (s: ss)
                                | existsOption (option s) o = [] ++ fill o ss
                                | otherwise = s : fill o ss  
                          in  list ++ fill list def

