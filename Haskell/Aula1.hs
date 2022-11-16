--Ex 1 
testaTriangulo :: Float -> Float -> Float -> Bool
testaTriangulo a b c = (a <=b+c) && (b <=a+c) && (c <=b+a)

--Ex 2
areaTriangulo :: Float -> Float -> Float -> Float
areaTriangulo a b c = sqrt (s*(s-a)*(s-b)*(s-c))
    where s = (a+b+c)/2

--Ex 3
metades :: [Float] -> ([Float],[Float])
metades original
        | length f == 1 = i ++ interpperse f
        | otherwise = o que escrevemos 
--divisão inteira