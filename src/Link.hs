module Link where

import Database.PostgreSQL.Simple.FromRow
import Database.PostgreSQL.Simple.Types


printLinks :: [Link] -> IO ()
printLinks [] = return ()
printLinks (x:xs) = putStr ("│  id    │ ") 
                    >> print(_id x) >> putStr ("│  link  │ ")
                       >> putStrLn (link x) >> putStr ("│  desc  │ ") 
                          >> putStrLn (description x) >> putStrLn("├────────────────────────────────────────")
                             >> printLinks xs


printDeleted :: Link -> IO ()
printDeleted link = putStrLn ("Deleted following link: \nid   │" ++ show (_id link)) >> putStrLn ("desc │" ++ description link)

data Link = Link {
    _id :: Integer,
    link :: [Char],
    description :: [Char]
} deriving (Eq)

instance FromRow Link where
    fromRow = Link <$> field <*> field <*> field