
import Lib
import Test.Hspec

main = hspec $ do
    describe "Command parses works ok" $ do
        it "Parses commands correctly" $ do
          (parse "-D mtg -d cute -u edo -w whatever") `shouldBe` [Option "D" (Just "mtg"), Option "d" (Just "cute"), Option "u" (Just "edo")]
          (parse "-D mtg -d cute -r --t -u edo -w whatever") `shouldBe` [Option "D" (Just "mtg"), Option "d" (Just "cute"), Option "u" (Just "edo")]
          (parse "-D") `shouldBe` [Option "D" Nothing]
          (parse "-D -d cute") `shouldBe` [Option "D" Nothing, Option "d" (Just "cute")]
          (parse "-n -D mtg") `shouldBe` [Option "D" (Just "mtg")]
          (parse "-n cc -D mtg") `shouldBe` [Option "D" (Just "mtg")]
          (parse "") `shouldBe` []
    describe "Can get options" $ do
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


