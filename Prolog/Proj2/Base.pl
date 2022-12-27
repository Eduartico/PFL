:- use_module(library(lists)).

printBoard(B):- maplist(writeLine, B).

writeLine(L):- writeq(L), nl.

startGame(Game):- 
    Line = ['w','w','w','w','w'],
    Board = [Line, Line, Line, Line, Line],
    printBoard(Board).