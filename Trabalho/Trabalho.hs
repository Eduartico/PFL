data M = M {num :: int | denom :: int | vars :: [string] | exps :: [int]}

norm :: [M] -> [M]
norm [] = []