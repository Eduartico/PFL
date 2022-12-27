:- use_module(library(lists)).

startGame:- 
    writeLine('Select Game Mode:'), writeLine('1: Player vs Player'), writeLine('2: Player vs PC'), writeLine('3: PC vs PC'),
    read(GameMode),
    (GameMode =:= 1 -> startPVP;
    GameMode =:= 2 -> startPVA;
    GameMode =:= 3 -> startAVA;
    clearScreen, writeLine('Invalid Input!'), startGame).

% Player vs PC ---------------------------------------------
startPVA:-
    writeLine('Select Difficulty:'), nl, writeq('Easy or Hard'), nl,
    read(Difficulty),
    writeLine('Let the games begin kekw'), nl,
    gameSetup,
%//game loop deve iniciar aqui
    playerInput.

    
% Player vs Player ---------------------------------------------

%//game loop deve iniciar aqui


% PC vs PC ---------------------------------------------

% Support functions ---------------------------------------------

printBoard(B):- maplist(writeLine, B).

writeLine(L):- writeq(L), nl.

clearScreen:- repeatNl(60).

repeatNl(0).
repeatNl(N):- N>0 ,nl, S is N-1, repeatNl(S).

gameSetup:-
    Line = ['W','W','W','W','W'],
    Board1 = [Line, Line, Line, Line, Line],
    nb_setval(board, Board1),
    printBoard(board),
    Color = 'B'.
loopRefresh:-
    (Color =:= 'B' -> Color = 'R';
    Color = 'B'),
    B is 0, R is 0,
    checkWin(Board)
    CT = 1, RT = 1.

playerInput:-
    writeLine('Please input your next tile'), 
    getCoord(MoveRow, 'Row:'),
    getCoord(MoveCol, 'Column:'),
    makeMove(MoveRow, MoveCol).

getCoord(Coord, Message):- writeLine(Message), read(Coord1), 
    ((integer(Coord1), Coord1 > 0 , Coord1 < 6) -> Coord = Coord1; 
    ((writeLine('Invalid Input!'), getCoord(Coord, Message)); true)).

validMove(MoveRow, MoveCol):-
    (MoveRow > 5 -> writeLine('Invalid Move!'); % todo condição
    nth1(MoveRow, Board, X), nth1(Move, Board, X), startGame).

makeMove(Row, Col):-
    printBoard(Board),
    read(Batata),
    Board2 = board,
    B is 0, R is 0,
    iterateMove(Row, Col, Board2, 1, B, R),
    (B =:= R -> board = Board2; (writeLine('Invalid Move!'), playerInput) ; true).

iterateMove(Row, Col, [], I, B, R).

iterateMove(Row, Col, [H|T], I, B, R):-
    ((I =:= Row + 1; I =:= Row - 1) -> checkRow(Col, H, 1, B, R);
    Row =:= I -> iterateRow(Col, H, 1, B, R); true),
    I1 is I+1,
    iterateMove(Row, Col, T, I1, B, R).

iterateRow(Col, [], J, B, R).

iterateRow(Col, [H, T], J, B, R):-
    ((J =:= Col + 1; J =:= Col - 1) -> (H =:= 'R' -> R1 is R+1, R = R1; H =:= 'B' -> B1 is B+1, B = B1; true);
    J =:= Col -> H = color; true),
    J1 is J+1,
    iterateRow(Col, T, J1, B, R).

checkRow(Col, [], J, B, R).

checkRow(Col, [H, T], J, B, R):-
    (J =:= Col -> (H =:= 'R' -> R1 = R+1, R = R1; H =:= 'B' -> B1 = B+1, B = B1; true);
    J1 = J+1,
    checkRow(Col, T, J1, B, R)).



checkWin(ColT, RowT):-
iterateMove(ColT, RowT, Board, 1, B, R),
(CT =:= 5; RT =:= 5 -> 
Color = 'B'),