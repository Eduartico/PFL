%4.
%a) ---------------------------
print_n:-
write('Please input S: '), nl,
get_char(S),
write('Please input N: '), nl,
read(N), 
N > 0,
N1 is N-1,
write(S),
print_nrec(S, N1).

print_nrec(S,N):-
N > 0,
N1 is N-1,
put_char(S),
print_nrec(S, N1).

%b) ---------------------------
print_text(Text,S,P):-
write(S),
print_nrec(' ',P),
print_textrec(Text),
print_nrec(' ',P),
write(S).

print_textrec([]):-.
print_textrec([H|T]):-
put_char(H), print_textrec(T).

