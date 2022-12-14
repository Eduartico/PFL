%1.
%a) ---------------------------------------------
double(X, Y):- Y is X*2.
map(_,[], []).
map(Pred, [H1|T1], [H2|T2]):-
G =..[Pred, H1, H2],
G,
map(Pred, T1, T2).
%b) ---------------------------------------------
sum(A, B, S):- S is A+B.
fold(_, Acc, [], Acc).
fold(Pred, S, [H|T], F):-
G =..[Pred, S, H, Acc],
G,
fold(Pred, Acc, T, F).
%c) ---------------------------------------------
even(X):- 0 =:= X mod 2.
separate([], _, [],[]).
separate([H|T], Pred, [H|Yes], No):-
G =..[Pred,H],
G,!,
separate(T, Pred, Yes, No).
separate([H|T], Pred, Yes, [H|No]):-
separate(T, Pred, Yes, No).
