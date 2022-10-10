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

-- 2.6 
--sum [x^2 | x<-[1..100]]

-- 2.8
myzip :: [Float] -> [Float] -> [Float]
myzip [] [] = []
myzip (i1:f1) (i2:f2) = [i1*i2] ++ myzip f1 f2
dotprod :: [Float] -> [Float] -> Float
dotprod l1 l2 = sum (myzip l1 l2)

--2.9
divprod :: Integer -> [Integer]
divprod x = [y | y<-[1..(x-1)], mod x y==0]

--2.10
perfeitos :: Integer -> [Integer]
perfeitos x = [y | y<-[1..(x-1)], sum (divprod y) == y]