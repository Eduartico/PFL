import Data.List

data M = M {num :: Float , vars :: [Char] , exps :: [Int]} deriving (Eq, Show, Ord)

norm :: [M] -> [M]
norm [] = []
{-
norm [] = []
norm Antiga [x:xs]
Nova insert (sumM (filter (\i xs, (x.vars == i.vars && x.exps == i.exps))))
xs = filter (lista antiga, (x.vars != i.vars && x.exps != i.exps)) 
Nova add (norm xs)
-}

--o bloco acima é um groupby (se funcionar)
--sortby precisa de uma função de seleção, kinda like função match ali embaixo but not really

sumM :: [M] -> M
sumM [] = M{num = 0, vars = [], exps = []}
sumM (i:f) = M {num = num i + num (sumM f),vars = vars i,exps = exps i}


multiM :: [M] -> M -- transformar para receber 2M 
multiM [] = M{num = 1, vars = [], exps = []}
multiM (i:f) = M {num = num i * num (multiM f),vars = vars i ++ vars (multiM f),exps = exps i ++ exps (multiM f)}
-- ^ works but need to apply norm after, example problem: (multiM [M 1.0 ['x'] [2], M 2.0 ['x'] [2]]) -> M {num = 2.0, vars = "xx", exps = [2,2]} 


--derivate :: [M] -> [M]

sortP ::  [M] -> [M]
sortP [] = []
sortP p [M] = sortby compareM p

compareM :: (Eq a, Ord a) => M -> M -> Ordering
compareM m1 m2
        |length exps m1 < 1 = GT
        |length exps m2 < 1 = LT
        |maximum exps m1 < maximum exps m2 = GT
        |maximum exps m1 == maximum exps m2 = compareM M {num = num m1, vars = vars m1, exps = [y | y <- exps m1, y != maximum vars m1]} M {num = num m2, vars = vars m2, exps = [y | y <- exps m2, y != maximum vars m2]}
        |maximum exps m1 > maximum exps m2 = LT