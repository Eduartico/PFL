-- 2.1
--a)
myAnd :: [Bool] -> Bool
myAnd [] = True
myAnd (i:f) = i && myAnd f
--b)
myOr :: [Bool] -> Bool
myOr [] = False
myOr (i:f) = i || myOr f
--c)
myConcat :: [[a]] -> [a]
myConcat [] = []
myConcat (i:f) = i ++ myConcat f
--f)
myElem :: Eq a => a -> [a] -> Bool
myElem e [] = False
myElem e (i:f) = i == e || myElem e f

-- 2.2
intersperse :: a -> [a] -> [a]
intersperse e [] = []
intersperse e (i:f)  
    |length f == 0 = [i] ++ f
    |otherwise = [i] ++ [e] ++ intersperse e f

-- 2.4
--a)
insert :: Ord a => a -> [a] -> [a]
insert e [] = [e]
insert e (i:f)
    |i < e = [i] ++ insert e f
    |otherwise = [e] ++ [i] ++ f
--b)
isort :: Ord a=> [a] -> [a]
isort [] = []
isort (i:f) = insert i (isort f)