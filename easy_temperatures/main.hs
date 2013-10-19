main :: IO ()
main = do
    n <- readLn :: IO Int -- ignore this number
    if n == 0 then
        print 0
    else do
        l <- getLine :: IO String
        let
            temps = map (\a -> read a :: Int) (words l)
        print $ foldl1 (\a b -> if abs a < abs b then a else b) temps
