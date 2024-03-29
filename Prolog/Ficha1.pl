female(grace). male(frank).
female(dede). male(jay). female(gloria). male(javier).
female(barb). male(merle).
male(phil). female(claire).
male(mitchell). male(joe). male(manny). male(cameron).
female(pameron). male(bo).
male(dylan). female(haley).
female(alex). male(luke).
female(lily). male(rexford).
male(calhoun).
male(george). female(popy).

parent(grace, phil). parent(frank, phil).
parent(dede, claire). parent(jay, claire).
parent(dede, mitchell). parent(jay, mitchell).
parent(jay, joe). parent(gloria, joe).
parent(gloria, manny). parent(javier, manny).
parent(barb, cameron). parent(merle, cameron).
parent(barb, pameron). parent(merle, pameron).
parent(phil, haley). parent(claire, haley).
parent(phil, alex). parent(claire, alex).
parent(phil, luke). parent(claire, luke).
parent(mitchell, lily). parent(cameron, lily).
parent(mitchell, rexford). parent(cameron, rexford).
parent(pameron, calhoun). parent(bo, calhoun).
parent(dylan, george). parent(haley, george).
parent(dylan, popy). parent(haley, popy).

father(X, Y):- male(X), parent(X, Y).
mother(X, Y):- female(X), parent(X, Y).
siblings(X, Y):- parent(Z, X), parent(Z, Y), parent(W, X), parent(W, Y), X \= Y, Z\=W.
halfsiblings(X, Y):- parent(Z, X), parent(Z, Y), parent(W, X), \+parent(W, Y), W\=Z.
cousins(X, Y):- parent(Z, X), parent(W, Y), siblings(Z, W). 