import Test.Hspec
import Test.QuickCheck
import Control.Exception (evaluate)
import Control.Monad
import Control.GroupBy
import Data.Map (Map)
import Data.List (sort)
import qualified Data.Map as Map


multimapElemEq (k1,v1) (k2,v2) = (k1 == k2) && (sort v1 == sort v2)

-- Check if two multimap-representing lists are equal,
-- disregarding value list order
multimapListEq :: (Ord a, Ord b, Eq a, Eq b) => [(a,[b])] -> [(a,[b])] -> Bool
multimapListEq xs ys =
    let zipped = zipWith multimapElemEq xs ys
    in and zipped

multimapEq :: (Ord a, Ord b, Eq a, Eq b) => Map a [b] -> Map a [b] -> Bool
multimapEq x y =
    multimapListEq (Map.toList x) (Map.toList y)

multimapTupleEq (x,y) = multimapEq x y

main :: IO ()
main = hspec $ do
  describe "groupBy" $ do
    it "should group a simple value correctly" $
        let data_ = ["a","abc","ab","bc"]
            fn = take 1
            ref = Map.fromList [("a",["a","abc","ab"]),("b",["bc"])]
            result = groupBy fn data_
        in (result, ref) `shouldSatisfy` multimapTupleEq

