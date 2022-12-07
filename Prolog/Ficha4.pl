%1.
:-dynamic male/1, female/1.
%a) ---------------------------------------------
add_person:-
write('Please input if they are male/female: '), nl,
read(S),
write('Please input their name: '), nl,
read(N), 
add(S,N).

add(male,N):- assertz(male(N)).
add(female,N):- assertz(female(N)).

%b) ---------------------------------------------
add_parents(Person):-
write('Please input the first parent: '), nl,
read(P1),
write('Please input the second parent: '), nl,
read(P2), 
p(P1,Person),
p(P2,Person).

p(P,S):- assertz(parent(P, S)).

%c) ---------------------------------------------
remove_person:-
write('Please input their name: '), nl,
read(N), 
retractall(parent(N,_)),
retractall(parent(_,N)),
retractall(male(N)),
retractall(female(N)).