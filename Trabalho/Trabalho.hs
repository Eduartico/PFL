import Data.List
import System.IO

data M = M {num :: Float , vars :: [(String , Int)]} deriving (Eq, Show, Ord)

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
sumM [] = M{num = 0, vars = []}
sumM (i:f) = M {num = num i + num (sumM f),vars = vars i}


multiM :: [M] -> M -- transformar para receber 2M 
multiM [] = M{num = 1, vars = []}
multiM (i:f) = M {num = num i * num (multiM f),vars = vars i ++ vars (multiM f)}
-- ^ works but need to apply norm after, example problem: (multiM [M 1.0 ['x'] [2], M 2.0 ['x'] [2]]) -> M {num = 2.0, vars = "xx", exps = [2,2]} 

derivateM :: M -> String -> M
derivateM m v
        |not (or (map(== v)(fst(unzip(vars m))))) = M{num = 0, vars = []}
        |snd ([y | y<-vars m, fst y == v] !! 0) == 1 = M{num = num m, vars = filter(\x -> fst x /= v)(vars m)}
        |otherwise = M {num = num m * (fromIntegral (snd ([y | y<-vars m, fst y == v] !! 0)) :: Float), vars = map(\x -> if fst x /= v then x else (fst x, snd x - 1))(vars m)}

sortP :: [M] -> [M]
sortP [] = []
sortP p = sortBy compareM p

maximumExp :: M -> (String, Int)
maximumExp m = if length (vars m) == 0 then ("",0) else sortBy(\x y -> if snd x > snd y then LT else GT)(vars m) !! 0

compareM :: M -> M -> Ordering
compareM m1 m2
        |length (vars m1) == 0 && length (vars m2) == 0 = LT
        |snd (maximumExp m1) /= snd (maximumExp m2) = if snd (maximumExp m1) > snd (maximumExp m2) then LT else GT
        |otherwise = compareM M {num = num m1, vars = filter(\x -> x/= maximumExp m1)(vars m1)} M {num = num m2, vars = filter(\x -> x/= maximumExp m2)(vars m2)}