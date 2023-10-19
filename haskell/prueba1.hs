import Data.Char
-- Init
-- ☁  haskell [main] ⚡  touch prueba1.hs
-- ☁  haskell [main] ⚡  code .    
-- ☁  haskell [main] ⚡  ghci 
-- GHCi, version 9.2.8: https://www.haskell.org/ghc/  :? for help
-- ghci> :l prueba1.hs
-- [1 of 1] Compiling Main             ( prueba1.hs, interpreted )
-- Ok, one module loaded.
-- ghci> inRange 5 7 6
-- True
-- ghci> inRange 5 5 5
-- True
-- ghci> 

-- String only
-- inRange:: Int -> Int -> Int -> Bool
inRange:: (Ord a) => a -> a -> a -> Bool
inRange l r v = l<=v && r>=v

-- FIBONACCI
fibonacci :: Int -> Int
fibonacci n
  | n < 0 = error "Negative!"
  | otherwise = _fibonacci n 1 0

_fibonacci :: Int -> Int -> Int -> Int
_fibonacci 0 _ n_2 = n_2
_fibonacci 1 n_1 _ = n_1
_fibonacci i n_1 n_2
  | i > 1 = _fibonacci (i - 1) (n_1 + n_2) n_1

setElemAt :: [a] -> a -> Int -> [a]
setElemAt _ _ i | i < 0 = error ("Invalid index "++ (show i) ++"!")
setElemAt (_:xs) y 0 = y:xs
setElemAt [] _ i = error ("Invalid index "++ (show i) ++"!")
setElemAt (x:xs) y i = x:(setElemAt xs y (i - 1))


operator:: Char -> ([Double]->[Double])
operator x
  | isDigit x = (\ns-> (read[x]):ns)
  | x =='+' = (\(n1:n2:ns)-> (n1 + n2):ns)
  | x =='-' = (\(n1:n2:ns)-> (n1 - n2):ns)
  | x =='*' = (\(n1:n2:ns)-> (n1 * n2):ns)
  | x =='/' = (\(n1:n2:ns)-> (n1 / n2):ns)
  | otherwise = error "Dato raro!"


evaluate :: String -> [Double]
evaluate lista = foldl (\acc x -> operator x acc) [] lista


data Angle = Degrees Double | Radians Double deriving (Eq, Show)

toDegrees:: Angle -> Angle
toDegrees (Radians x)= Degrees (x * (180/pi))
toDegrees (Degrees x)= Radians (x * (pi/180))


detElemAt :: [a] -> a -> Int -> [a]
detElemAt _ _ i | i < 0 = error ("Invalid index "++ (show i) ++"!")
detElemAt (_:xs) y 0 = y:xs
detElemAt [] _ i = error ("Invalid index "++ (show i) ++"!")
detElemAt (x:xs) y i = x:(setElemAt xs y (i - 1))


-- delat :: [a] -> Int -> [a]
-- delat _ i | i < 0 = error ("Invalid index "++ (show i) ++"!")
-- delat (_:xs) 0 = xs
-- delat [] i = error ("Invalid index "++ (show i) ++"!")
-- delat (x:xs) i = (delat xs (i - 1))


delat :: (Ord a) => [a] -> Int -> [a]
delat _ i | i < 0 = error ("Invalid index "++ (show i) ++"!")
delat (_:xs) 0 = xs
delat [] i = error ("Invalid index "++ (show i) ++"!")
delat (x:xs) i = x:(delat xs (i - 1))


isSortedC :: (Ord a) => [a] -> Bool
isSortedC (x:xs) =  (filter (\(x1,x2) -> x1>x2 ) (zip (x:xs) xs)) ==[]
isSortedC _ = True

isSorted :: (Ord a) => [a] -> Bool -> Bool
isSorted (x:xs) asc =  (filter (\(x1,x2) -> if asc then x1>x2 else x1<x2 ) (zip (x:xs) xs)) == []
isSorted _ _ = True