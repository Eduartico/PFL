data M = M {num :: Float , vars :: [Char] , exps :: [Int]} deriving (Eq, Show)

norm :: [M] -> [M]
norm [] = []
{-
norm [] = []
norm Antiga [x:xs]
Nova insert (sumM (filter (\i xs, (x.vars == i.vars && x.exps == i.exps))))
xs = filter (lista antiga, (x.vars != i.vars && x.exps != i.exps)) 
Nova add (norm xs)
-}

--import Data.List groupby e sortby
--o bloco acima é um groupby (se funcionar)
--sortby precisa de uma função de seleção, kinda like função match ali embaixo but not really

sumM :: [M] -> M
sumM [] = M{num = 0, vars = [], exps = []}
sumM (i:f) = M {num = num i + num (sumM f),vars = vars i,exps = exps i}

--sortP :: [M] -> [M]


multiM :: [M] -> M
multiM [] = M{num = 1, vars = [], exps = []}
multiM (i:f) = M {num = num i * num (multiM f),vars = vars i ++ vars (multiM f),exps = exps i ++ exps (multiM f)}
-- ^ works but need to apply norm after, example problem: (multiM [M 1.0 ['x'] [2], M 2.0 ['x'] [2]]) -> M {num = 2.0, vars = "xx", exps = [2,2]} 


--derivate :: [M] -> [M]



{-
matchM :: [M] -> Bool
matchM P [] = False
matchM P [x:xs]
    | (x.vars == y.vars && x.exps == y.exps) = True
    | Otherwise = False
-}