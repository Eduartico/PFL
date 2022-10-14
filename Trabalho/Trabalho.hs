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

sumM :: [M] -> M
sumM [] = M{num = 0, vars = ['0'], exps = [0]}
sumM (i:f) = M {num = num i + num (sumM f),vars = vars i,exps = exps i}

--sortP :: [M] -> [M]


--multiM :: [M] -> [M]


--derivate :: [M] -> [M]



{-
matchM :: [M] -> Bool
matchM P [] = False
matchM P [x:xs]
    | (x.vars == y.vars && x.exps == y.exps) = True
    | Otherwise = False
-}