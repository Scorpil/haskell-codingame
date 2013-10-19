import Data.Char
import Numeric


zerofill :: Int -> String -> String
zerofill size s
    | size == length s = s
    | otherwise = zerofill size ('0':s)

intToBinZerofill :: Int -> Int -> String
intToBinZerofill size i = zerofill size result
    where
        result = showIntAtBase 2 intToDigit i ""

chuckEncode :: String -> String
chuckEncode s = init $ chuckEncode' s --drop last space
    where
        chuckEncode' :: String -> String
        chuckEncode' [] = []
        chuckEncode' (c:s) = unwords [predicat, replicate (groupSize+1) '0', chuckEncode' sTail]
            where
                groupSize = length $ takeWhile (==c) s
                sTail = drop groupSize s
                predicat = if c == '0' then "00" else "0"


main :: IO ()
main = do
    s <- getLine :: IO String
    let
        binLn = foldl1 (++) $ map (\c -> intToBinZerofill 7 (ord c)) s
    putStrLn $ chuckEncode binLn
