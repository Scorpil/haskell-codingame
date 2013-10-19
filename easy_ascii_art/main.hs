import Data.Char

-- groups list into sublists, e.g.: group(2, [1,2,3,4]) == [[1,2], [3,4]]
group :: Int -> [a] -> [[a]]
group _ [] = []
group n l = (take n l) : (group n (drop n l))

-- Returns one line chunk of ascii letter
asciiLetterLine :: String -> [String] -> Char -> String
asciiLetterLine (a:[]) (g:[]) _ = g
asciiLetterLine (a:alph) (g:groups) letter
    | a == letter = g
    | otherwise = asciiLetterLine alph groups letter

-- Returns one line portion of resulting text
asciiLines :: Int -> String -> [String] -> [String]
asciiLines _ _ [] = []
asciiLines cols text (asciiLn:asciiLns) =
    let
        alph = "ABCDEFGHIJKLMNOPQRSTUVWXYZ?"
        lineList = map (asciiLetterLine alph (group cols asciiLn)) text
        line = foldl1 (++) lineList
    in
      line:(asciiLines cols text asciiLns)

process input =
    let
        t1:t2:t3:ascii = lines input
        cols = read t1 :: Int
        rows = read t2 :: Int
        text = map toUpper t3
    in
      unlines $ asciiLines cols text ascii

main :: IO ()
main = interact process
