{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use infix" #-}
{-# HLINT ignore "Use map" #-}
{-# HLINT ignore "Avoid lambda" #-}
{-# HLINT ignore "Use newtype instead of data" #-}
import Data.List
import System.IO

data M = M {num :: Float , vars :: [(String , Int)]} deriving (Eq, Show, Ord)
data P = P {mons :: [M]} deriving (Eq, Show, Ord)

--Normalização

pToString :: P -> String
pToString (P []) = ""
pToString (P (i:f)) = mToString i ++ concatMap (\m -> (if num m > 0 then " +" else " ") ++ mToString m)f

mToString :: M -> String
mToString m = show(num m) ++ concatMap(\t -> "*" ++ fst t ++ "^" ++ show(snd t))(vars m)

norm :: P -> P
norm p = P{mons = sortP(sumM(map(\x -> M{num = num x, vars = sort (vars x)})(mons p)))}

normalize :: P -> String
normalize p = pToString(norm p)
--Somas

sumP :: P -> P -> P
sumP p1 p2 = norm P{mons = mons p1 ++ mons p2}

sumM :: [M] -> [M]
sumM [] = []
sumM (m:ms) = foldl(\x y -> M{num = num x + num y, vars = vars x}) m (filter(\x-> sort(vars x) == sort(vars m)) ms) : sumM (filter(\x -> sort(vars x) /= sort(vars m))ms)

--Multiplicação

multiply :: P -> P -> String
multiply p1 p2 = pToString(multiP p1 p2)

multiP :: P-> P-> P
multiP p1 p2 = norm(P{mons = foldl(\x y -> x ++ multiM (mons p2) y)[](mons p1)})

multiM :: [M] -> M -> [M]
multiM ms m = map(\x -> M{num = num x * num m, vars = normVars (vars x ++ vars m)})ms
--multiM (i:f) m = M{num = num i * num m, vars = normVars (vars i ++ vars m)} : f

normVars :: [(String, Int)] -> [(String, Int)]
normVars [] = []
normVars (x:xs)
        |elem (fst x) (fst(unzip xs)) = map(\y -> if fst y == fst x then (fst y, snd y + snd x) else y) xs
        |otherwise = x : xs

--Derivação

derivateP :: P -> String -> P
derivateP p v = P{mons = filter(\m -> not(null (vars m)))(map(`derivateM` v)(mons p))}

derivateM :: M -> String -> M
derivateM m v
        |notElem v (fst(unzip(vars m))) = M{num = 0, vars = []}
        |snd (head ([y | y<-vars m, fst y == v])) == 1 = M{num = num m, vars = filter(\x -> fst x /= v)(vars m)}
        |otherwise = M {num = num m * (fromIntegral (snd (head ([y | y<-vars m, fst y == v]))) :: Float), vars = map(\x -> if fst x /= v then x else (fst x, snd x - 1))(vars m)}

--Sort

sortP :: [M] -> [M]
sortP [] = []
sortP p = sortBy compareM p

maximumExp :: M -> (String, Int)
maximumExp m = if null (vars m) then ("",0) else maximumBy (\x y -> if snd x < snd y then LT else GT) (vars m)

compareM :: M -> M -> Ordering
compareM m1 m2
        |null (vars m1) && null (vars m2) = LT
        |snd (maximumExp m1) /= snd (maximumExp m2) = if snd (maximumExp m1) > snd (maximumExp m2) then LT else GT
        |otherwise = compareM M {num = num m1, vars = filter(\x -> x/= maximumExp m1)(vars m1)} M {num = num m2, vars = filter(\x -> x/= maximumExp m2)(vars m2)}