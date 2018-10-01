module Fill where
import Command

defaultDatabase :: Option
defaultDatabase = Option "D" $ Just "mtg" -- TODO add default database

defaultTable :: Option
defaultTable = Option "t" $ Just "creatures" -- TODO add default table name

defaultUsername :: Option
defaultUsername = Option "u" $ Just "postgres" -- TODO add default username

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

