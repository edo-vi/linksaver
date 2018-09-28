module Builder where
    
import Command
import Fill

-- | Builds a Command 
buildCommand :: [Option] -> [Option] -> Command
buildCommand [] [] = Command []
buildCommand def parsed = Command $ fillDefaults def parsed