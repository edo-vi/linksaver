
import Lib
import Test.Hspec

main = hspec $ do
    describe "Command parses works ok" $ do
        it "Parses commands correctly" $ do
          (parse "-D mtg -d cute -u edo -w whatever") `shouldBe` [Option "D" "mtg", Option "d" "cute", Option "u" "edo"]
          (parse "-D mtg -d cute -r --t -u edo -w whatever") `shouldBe` [Option "D" "mtg", Option "d" "cute", Option "u" "edo"]
          (parse "-D") `shouldBe` []
          (parse "-D -d cute") `shouldBe` [Option "d" "cute"]
          (parse "-n -D mtg") `shouldBe` [Option "D" "mtg"]
          (parse "-n cc -D mtg") `shouldBe` [Option "D" "mtg"]
          (parse "") `shouldBe` []