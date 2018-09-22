
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