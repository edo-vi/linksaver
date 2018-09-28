
import Lib
import Command
import Fill

import Test.Hspec

main = hspec $ do
    describe "Parsing" $ do
        it "Parses commands correctly" $ do
          (parse "-D mtg -d cute -u edo -w whatever") `shouldBe` [Option "D" (Just "mtg"), Option "d" (Just "cute"), Option "u" (Just "edo")]
          (parse "-D mtg -d cute -q --z -u edo -w whatever") `shouldBe` [Option "D" (Just "mtg"), Option "d" (Just "cute"), Option "u" (Just "edo")]
          (parse "-D") `shouldBe` [Option "D" Nothing]
          (parse "-D -d cute") `shouldBe` [Option "D" Nothing, Option "d" (Just "cute")]
          (parse "-n -D mtg") `shouldBe` [Option "D" (Just "mtg")]
          (parse "-n cc -D mtg") `shouldBe` [Option "D" (Just "mtg")]
          (parse "") `shouldBe` []
          (parse "-rd") `shouldBe` []
          (parse "-l -d ciao come va") `shouldBe` [Option "l"  Nothing, Option "d" (Just "ciao come va")]
          (parse "--l -d") `shouldBe` [Option "l"  Nothing, Option "d" Nothing]
          (parse "-s -d Descrizione del link") `shouldBe` [Option "s" Nothing, Option "d" (Just "Descrizione del link")]
          (parse "-rd ciao tse -l -dr") `shouldBe` [Option "l" Nothing]
        it "Check correctly if options exists and can get them from a command" $ do
          let com1 = parse "-D mtg -d cute -u edo -w whatever -l"
              com2 = parse ""
          existsOption "D" com1 `shouldBe` True
          existsOption "-D" com1 `shouldBe` True
          existsOption "l" com1 `shouldBe` True
          existsOption "" com1 `shouldBe` False
          existsOption "cute" com1 `shouldBe` False
          existsOption "l" com2 `shouldBe` False
          existsOption "" com2 `shouldBe` False

          getOption "D" com1 `shouldBe` Just (Option "D" (Just "mtg"))
          getOption "-D" com1 `shouldBe` Just (Option "D" (Just "mtg"))
          getOption "" com1 `shouldBe` Nothing
          getOption "D" com2 `shouldBe` Nothing
          getOption "-D" com2 `shouldBe` Nothing
          getOption "" com2 `shouldBe` Nothing
    describe "Filling" $ do
      it "Fills correctly default option" $ do
        let com1 = Command (parse "-D mtg -d cute -u edo -w whatever -l")
            com2 = Command (parse "")
            com3 = Command (parse "-D nondefault -t nondefault -u nondefault")
            com4 = Command (parse "-d nondefault -t nondefault -u nondefault")
            defaultDatabase = Option "D" (Just "mtg")
            defaultUsername = Option "u" (Just "postgres")
            defaultTable = Option "t" (Just "creatures")
            defaults = [defaultDatabase, defaultUsername, defaultTable]
            nondefaults = []
        fillDefaultsCommand defaults com1 `shouldBe` Command [Option "D" (Just "mtg"), 
            Option "d" (Just "cute"), Option "u" (Just "edo"), Option "l" Nothing, defaultTable]
        fillDefaultsCommand defaults com2 `shouldBe` Command defaults
        fillDefaultsCommand defaults com3 `shouldBe` com3
        fillDefaultsCommand defaults com4 `shouldBe` Command [Option "d" (Just "nondefault"), 
            Option "t" (Just "nondefault"), Option "u" (Just "nondefault"),defaultDatabase ]
        fillDefaultsCommand nondefaults com1 `shouldBe` com1
        fillDefaultsCommand nondefaults com2 `shouldBe` com2
        fillDefaultsCommand nondefaults com3 `shouldBe` com3




