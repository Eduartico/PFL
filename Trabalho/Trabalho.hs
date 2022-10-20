{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use infix" #-}
{-# HLINT ignore "Use map" #-}
{-# HLINT ignore "Avoid lambda" #-}
{-# HLINT ignore "Use newtype instead of data" #-}
{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
import Data.List
import System.IO
import Data.Char

data M = M {num :: Float , vars :: [(String , Int)]} deriving (Eq, Show, Ord)
data P = P {mons :: [M]} deriving (Eq, Show, Ord)

--Manipulação de String

stringToP :: String -> P
stringToP s = P{mons = parseStoM(words s)}

parseStoM :: [String] -> [M]
parseStoM [] = []
parseStoM (s:f)
        |s == "+" || s == "-" = parseStoM((s ++ head f): tail f)
        |otherwise = (M {num = parseNum (grpDigs s), vars =  parseVars (grpDigs s)}) : parseStoM f

grpDigs :: String -> [String]
grpDigs = groupBy(\c1 c2 -> (isDigit c1 || c1 == '.') == (isDigit c2 || c2 == '.') && (c1 == '*') == (c2 == '*'))

scnd :: [a] -> a
scnd xs = head(tail xs)

parseNum :: [String] -> Float
parseNum s
        |head (head s) == '-' = (-1.0) * if length(head s)  == 1 then (read(scnd s) :: Float) else 1
        |head (head s) == '+' = if length(head s)  == 1 then (read(scnd s) :: Float) else 1
        |isDigit(head (head s)) = read(head s) :: Float
        |otherwise = 1

parseVars :: [String] -> [(String, Int)]
parseVars [] = []
parseVars (x:xs)
        |x == "-" || x == "+" || isDigit(head x) || x == "*" = parseVars xs
        |elem '^' x = (filter(`notElem` "+-^*")x, read(head xs)::Int) : parseVars(tail xs)
        |otherwise = (filter(`notElem` "+-^*")x,1) : parseVars(xs)

pToString :: P -> String
pToString (P []) = ""
pToString (P (i:f)) = mToString i ++ concatMap (\m -> (if num m > 0 then " +" else " ") ++ mToString m)f

mToString :: M -> String
mToString m
        |num m == (-1) = "-" ++ mToString(M{num = 1, vars = vars m})
        |num m /= 1 = show(num m) ++ concatMap(\t -> "*" ++ fst t ++ (if snd t /= 1 then "^" ++ show(snd t) else ""))(vars m)
        |otherwise = tail (concatMap(\t -> "*" ++ fst t ++ (if snd t /= 1 then "^" ++ show(snd t) else ""))(vars m))

--Normalização

norm :: P -> P
norm p = P{mons = sortP(filter (\m -> num m/=0) (sumM(map(\x -> M{num = num x, vars = sort(normVars(vars x))})(mons p))))}

normalize :: P -> String
normalize p = pToString(norm p)

normalizeS :: String -> String
normalizeS s = normalize(stringToP s)

normVars :: [(String, Int)] -> [(String, Int)]
normVars [] = []
normVars (x:xs) = foldl(\y z -> (fst y, snd y + snd z)) x (filter(\y-> fst y == fst x) xs) : normVars (filter(\y-> fst y /= fst x)xs)

--Somas

somaS :: String -> String -> String
somaS s1 s2 = soma (stringToP s1) (stringToP s2)

soma :: P -> P -> String
soma p1 p2 = normalize P{mons = mons p1 ++ mons p2}

sumP :: P -> P -> P
sumP p1 p2 = norm P{mons = mons p1 ++ mons p2}

sumM :: [M] -> [M]
sumM [] = []
sumM (m:ms) = foldl(\x y -> M{num = num x + num y, vars = vars x}) m (filter(\x-> sort(vars x) == sort(vars m)) ms) : sumM (filter(\x -> sort(vars x) /= sort(vars m))ms)

--Multiplicação

multiplyS :: String -> String -> String
multiplyS s1 s2 = multiply (stringToP s1) (stringToP s2)

multiply :: P -> P -> String
multiply p1 p2 = pToString(multiP p1 p2)

multiP :: P-> P-> P
multiP p1 p2 = norm(P{mons = foldl(\x y -> x ++ multiM (mons (norm p2)) y)[](mons (norm p1))})

multiM :: [M] -> M -> [M]
multiM ms m = map(\x -> M{num = num x * num m, vars = normVars (vars x ++ vars m)})ms

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

compareM :: M -> M -> Ordering
compareM m1 m2
        |null (vars m2) = LT
        |null (vars m1) = GT 
        |fst (head (vars m1)) /= fst (head (vars m2)) = if fst (head (vars m1)) < fst (head (vars m2)) then LT else GT
        |snd (head (vars m1)) /= snd (head (vars m2)) = if snd (head (vars m1)) > snd (head (vars m2)) then LT else GT
        |otherwise = compareM M {num = num m1, vars = tail(vars m1)} M {num = num m2, vars = tail(vars m2)}