module Main where
import Command
import System.Environment (getArgs)
import System.Hclip(getClipboard)
import Fill(defaultOptions)
import Builder(buildCommand)

main :: IO ()
main = do
    getArgs >>= -- IO [string] containing the options
        (\options -> getClipboard >>=
            \clip -> print $ buildCommand (Option "l" (Just clip) : defaultOptions) (parseList options))
