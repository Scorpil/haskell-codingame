import Control.Monad
import Prelude hiding (id)
import Data.Sequence as Seq hiding (fromList)
import Data.Foldable (toList)


data Coordinates = Coordinates { long :: Float
                               , lat :: Float
                               } deriving Show

data Defib = Defib { id :: Int
                   , name :: String
                   , adress :: String
                   , phone :: String
                   , coordinates :: Coordinates
                   } deriving Show

-- General utils
readFloat :: Char -> String -> Float
readFloat delim s = read (replace delim '.' s) :: Float

replace :: Char -> Char -> String -> String
replace _ _ "" = ""
replace c1 c2 (c:s) = if c == c1 then c2:(replace c1 c2 s)
                    else c:(replace c1 c2 s)

splitOn :: Char -> String -> [String]
splitOn =
    let
      splitOn' chunk _ [] = (toList chunk):[]
      splitOn' chunk delim (x:xs) =
        if x == delim then (toList chunk):(splitOn' Seq.empty delim xs)
        else splitOn' (chunk Seq.|> x) delim xs
    in
      splitOn' Seq.empty


-- Defib loading
fromList :: [String] -> Defib
fromList l = Defib { id = read (l !! 0) :: Int
                   , name = l !! 1
                   , adress = l !! 2
                   , phone = l !! 3
                   , coordinates = Coordinates {
                       long = readFloat ',' (l !! 4)
                     , lat = readFloat ',' (l !! 5)
                     }
                   }

fromString :: String -> Defib
fromString = fromList . splitOn ';'


-- Calculate distance between two points
distance :: Coordinates -> Coordinates -> Float
distance p1 p2 = let
  x = ((long p2) - (long p1)) * cos(((lat p1) + (lat p2)) / 2)
  y = (lat p2) - (lat p1)
  in
   sqrt((x * x) + (y * y)) * 6371


main = do
  --reading input
  long <- getLine
  lat <- getLine
  n <- readLn :: IO Int
  defs <- forM [1..n] (\_ -> do
                          ln <- getLine
                          return (fromString ln))
  let
    me = Coordinates{ long=(readFloat ',' long)
                    , lat=(readFloat ',' lat)
                    }
    distanceToMe = distance me
    -- There must be a better way to compare this things
    closest = foldl1 (\defib1 defib2 -> if (distanceToMe $ coordinates defib1) <
                                           (distanceToMe $ coordinates defib2)
                                        then defib1
                                        else defib2) defs
    in
   putStrLn $ name closest
