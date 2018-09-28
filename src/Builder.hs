module Builder where
    
import Command
import Fill
import Database.PostgreSQL.Simple
import Data.Maybe

-- | Builds a Command 
buildCommand :: [Option] -> [Option] -> Command
buildCommand [] [] = Command []
buildCommand def parsed = Command $ fillDefaults def parsed

buildConnection :: Command -> IO Connection
buildConnection (Command c) = let database = fromJust . value . fromJust $ getOption "D" c -- we use fromJust because database and user 
                                  user = fromJust . value . fromJust $ getOption "u" c     -- should alway be present in the command, and are 
                                in connect $ ConnectInfo "localhost" 5432 user "" database -- always a string, never Nothing