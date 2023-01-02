:- use_module(library(lists)).
:- dynamic board/1, color/1.
startGame:- 
    writeLine('Select Game Mode:'), writeLine('1: Player vs Player'), writeLine('2: Player vs PC'), writeLine('3: PC vs PC'),
    read(GameMode),
    (\+(integer(GameMode)) -> clearScreen, writeLine('Invalid Input!'), startGame;
    GameMode =:= 1 -> startPVP;
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
    gameLoop.

gameLoop:-
    (checkWin -> fail;
    playerInput, clearScreen, printBoard, changeColor, gameLoop
    ).

changeColor:-
    color(Color),
    (Color =:= 1 -> set_color(2); set_color(1)).
    
% Player vs Player ---------------------------------------------

%//game loop deve iniciar aqui


% PC vs PC ---------------------------------------------

% Support functions ---------------------------------------------

printBoard:- board(Board), maplist(writeBoardLine, Board).

writeBoardLine(L):- maplist(writeBoardChar, L), nl.

writeBoardChar(C):- (C =:= 0 -> writeq('W'); C =:= 1 -> writeq('B'); writeq('R')).

writeLine(L):- writeq(L), nl.

clearScreen:- repeatNl(60).

repeatNl(0).
repeatNl(N):- N>0 ,nl, S is N-1, repeatNl(S).

set_board(Value):-
    retractall(board(_)), asserta(board(Value)).

set_color(Value):-
    retractall(color(_)), asserta(color(Value)).

gameSetup:-
    Line = [2, 0, 1, 1, 1],
    Board = [Line, Line, Line, Line, Line],
    set_board(Board),
    printBoard,
    set_color(1).
loopRefresh:-
    (color =:= 'B' -> color = 'R';
    color = 'B'),
    B is 0, R is 0,
    %%checkWin,
    CT = 1, RT = 1.

playerInput:-
    writeLine('Please input your next tile'), 
    getCoord(MoveRow, 'Row:'),
    getCoord(MoveCol, 'Column:'),
    makeMove(MoveRow, MoveCol).

getCoord(Coord, Message):- writeLine(Message), read(Coord1), 
    ((integer(Coord1), Coord1 > 0 , Coord1 < 6) -> Coord = Coord1; 
    ((writeLine('Invalid Input!'), getCoord(Coord, Message)); true)).

/*validMove(MoveRow, MoveCol):-
    (MoveRow > 5 -> writeLine('Invalid Move!'); % todo condição
    nth1(MoveRow, Board, X), nth1(Move, Board, X), startGame).*/

makeMove(Row, Col):-
    board(Board),
    (checkMove(Row, Col, Board, 1, 0, 0)-> 
        board2(Board2), putMove(Row, Col, Board, Board2, 1), set_board(Board2); 
        (writeLine('Invalid Move!'), playerInput) ; true).

board2(Board2):-
    Board2 = [A, B, C, D, E].

checkMove(Row, Col, [], I, B, R):- R =:= B.

checkMove(Row, Col, [H|T], I, B, R):-
    I1 is I+1,
    ((Row =:= I + 1 ; Row =:= I - 1) -> (
        checkRow(Col, H, 1, 1) -> B1 is B + 1, checkMove(Row, Col, T, I1, B1, R);
        checkRow(Col, H, 1, 2) -> R1 is R + 1, checkMove(Row, Col, T, I1, B, R1);
        checkMove(Row, Col, T, I1, B, R)
    );
    Row =:= I -> (
        (checkRow(Col, H, 1, 1) ; checkRow(Col, H, 1, 2)) -> fail;
        (checkRow(Col - 1, H, 1, 1), checkRow(Col + 1, H, 1, 1)) -> B1 is B + 2, checkMove(Row, Col, T, I1, B1, R); 
        (checkRow(Col - 1, H, 1, 2), checkRow(Col + 1, H, 1, 2)) -> R1 is R + 2, checkMove(Row, Col, T, I1, B, R1);
        checkRow(Col - 1, H, 1, 1) -> (
            B1 is B + 1,
            (checkRow(Col + 1, H, 1, 2) -> 
                R1 is R + 1, checkMove(Row, Col, T, I1, B1, R1); 
                checkMove(Row, Col, T, I1, B1, R)
            )
        );
        checkRow(Col - 1, H, 1, 2) -> (
            R1 is R + 1,
            (checkRow(Col + 1, H, 1, 1) -> 
                B1 is B + 1, checkMove(Row, Col, T, I1, B1, R1); 
                checkMove(Row, Col, T, I1, B, R1)
            )
        );
        checkRow(Col + 1, H, 1, 1) -> B1 is B + 1, checkMove(Row, Col, T, I1, B1, R);
        checkRow(Col + 1, H, 1, 2) -> R1 is R + 1, checkMove(Row, Col, T, I1, B, R1);
        checkMove(Row, Col, T, I1, B, R)
    );
    checkMove(Row, Col, T, I1, B, R)
).

putMove(Row, Col, [], [], I).

putMove(Row, Col, [H1|T1], [H2|T2], I):-
    I1 is I + 1,
    (Row =\= I -> H2 = H1, putMove(Row, Col, T1, T2, I1);
    board2(H2), putMoveRow(Col, H1, H2, 1), putMove(Row, Col, T1, T2, I1)
    ).
    
putMoveRow(Col, [], [], J).

putMoveRow(Col, [H1|T1], [H2|T2], J):-
    J1 is J + 1,
    (Col =\= J -> H2 = H1, putMoveRow(Col, T1, T2, J1);
    color(Color), H2 = Color, putMoveRow(Col, T1, T2, J1)
    ).

checkRow(Col, [], J, Color).

checkRow(Col, [H|T], J, Color):-
    ((Col =:= 0 ; Col =:= 6) -> fail;
    (J =:= Col) -> H =:= Color;
    J1 is J + 1, 
    checkRow(Col, T, J1, Color)).

checkWin:- 
    board(Board),
    tryMoves(Board, 1).

tryMoves([], I).

tryMoves([H|T], I):-
    tryRow(H, I, 1),
    tryMoves(T, I + 1).

tryRow([], I, J).

tryRow([H|T], I, J):-
    board(Board),
    \+checkMove(I, J, Board, 1, 0, 0),
    tryRow(T, I, J + 1).