import Control.Monad
import qualified Data.Map as Map
import qualified Data.Char as Char
import qualified Data.List as List


readMap :: Int -> IO (Map.Map String String)
readMap c =
    let
        readMap' 0 map = return map
        readMap' c map = do
          line <- getLine
          readMap' (c-1) (addExtMap line map)
    in
      readMap' c Map.empty

addExtMap :: String -> Map.Map String String -> Map.Map String String
addExtMap line extMap = let
        (ext:mime:[]) = words line
    in
        Map.insert (map Char.toLower ext) mime extMap

takeExt :: String -> Maybe String
takeExt filename = case List.find (=='.') filename of
                     Nothing -> Nothing
                     Just _ -> Just (reverse $ takeWhile (/='.') $ reverse filename)


main :: IO ()
main = do
    n <- readLn :: IO Int
    q <- readLn :: IO Int

    extMap <- readMap n
    exts <- forM [1..q] (\_ -> do
        f <- getLine
        putStrLn $ case takeExt f of
                  Nothing -> "UNKNOWN"
                  Just ext -> case Map.lookup (map Char.toLower ext) extMap of
                                Nothing -> "UNKNOWN"
                                Just s -> s)
    return ()
