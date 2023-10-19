
inRange:: (Ord a) => a -> a -> a -> Bool
inRange l r v = l<=v && r>=v


fibonacci :: Int -> Int
fibonacci n
  | n < 0 = error "Negative!"
  | otherwise = _fibonacci n 1 0

_fibonacci :: Int -> Int -> Int -> Int
_fibonacci 0 _ n_2 = n_2
_fibonacci 1 n_1 _ = n_1
_fibonacci i n_1 n_2
  | i > 1 = _fibonacci (i - 1) (n_1 + n_2) n_1


allEqual :: [Int] -> Bool
allEqual [_] = error "Ta mal!"
allEqual [] = error "Ta mal!"
allEqual (x:xs) = (filter (==x) xs) == xs

isSorted :: (Ord a) => [a] -> Bool
isSorted (x:xs) =  (filter (\(x1,x2) -> x1>x2 ) (zip (x:xs) xs)) ==[]
isSorted _ = True

bests :: ( a ->Double) -> [a] -> [a]
bests f lista =  filter  (\elem -> f elem == max)  lista
  where max =  maximum (map f lista)

