:- use_module(library(lists)).
:- use_module(library(random)).
:- use_module(library(system)).
:- dynamic board/1, color/1, difficulty/1.

% Main ---------------------------------------------
play:- 
    writeLine('Select Game Mode:'), writeLine('1: Player vs Player'), writeLine('2: Player vs PC'), writeLine('3: PC vs PC'),
    read(GameMode),
    (\+(integer(GameMode)) -> clearScreen, writeLine('Invalid Input!'), play;
    GameMode =:= 1 -> startPVP;
    GameMode =:= 2 -> startPVA;
    GameMode =:= 3 -> startAVA;
    clearScreen, writeLine('Invalid Input!'), play).

% Player vs AI ---------------------------------------------
startPVA:-
    writeLine('Select Difficulty:'), nl, writeq('Easy or Hard'), nl,
    read(Difdummy),
    ((Difdummy = 'Easy' ; Difdummy = 'easy' ; Difdummy = 'E' ; Difdummy = 'e')-> set_difficulty(1);
    (Difdummy = 'Hard' ; Difdummy = 'hard' ; Difdummy = 'H' ; Difdummy = 'h')-> set_difficulty(2);
    writeLine('Invalid Input!'), startPVA),
    writeLine('The game is about to start!'), nl,
    gameSetup,
    (gameLoopPVA-> true;
    printWin, play).

gameLoopPVA:-
    (checkWin -> fail;
    playerInput, clearScreen, printBoard, sleep(1.5), changeColor, 
    aiMove, /*Check Win*/ changeColor, gameLoopPVA
    ).
    
% Player vs Player ---------------------------------------------

startPVP:-
    writeLine('The game is about to start!'), nl,
    gameSetup,
    (gameLoopPVP-> true;
    printWin, play).

gameLoopPVP:-
    (checkWin -> fail;
    playerInput, clearScreen, printBoard, sleep(1.5), changeColor, gameLoopPVP
    ).


% AI vs AI ---------------------------------------------

startAVA:-
    writeLine('The game is about to start!'), nl,
    gameSetup,
    (gameLoopAVA-> true;
    printWin, play).

gameLoopAVA:-
    (checkWin -> fail;
    aiMove, changeColor, changeDifficulty, gameLoopAVA
    ).

% Swaps and sets ------------------------------------------------------------------------------------------

set_board(Value):-
    retractall(board(_)), asserta(board(Value)).

set_color(Value):-
    retractall(color(_)), asserta(color(Value)).

set_difficulty(Value):-
    retractall(difficulty(_)), asserta(difficulty(Value)).

changeColor:-
    color(Color),
    (Color =:= 1 -> set_color(2); set_color(1)).

changeDifficulty:-
    difficulty(Difficulty),
    (Difficulty =:= 1 -> set_difficulty(2); set_difficulty(1)).


% Game logic ------------------------------------------------------------------------------------------

gameSetup:-
    Line = [0, 0, 0, 0, 0],
    Board = [Line, Line, Line, Line, Line],
    set_board(Board),
    printBoard,
    set_difficulty(1),
    set_color(1).

getCoord(Coord, Message):- writeLine(Message), read(Coord1), 
    ((integer(Coord1), Coord1 > 0 , Coord1 < 6) -> Coord = Coord1; 
    ((writeLine('Invalid Input!'), getCoord(Coord, Message)); true)).

/*validMove(MoveRow, MoveCol):-
    (MoveRow > 5 -> writeLine('Invalid Move!'); % todo condição
    nth1(MoveRow, Board, X), nth1(Move, Board, X), play).*/

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

aiMove:-
writeLine('Your opponent made a move!'),
difficulty(Difficulty),
(Difficulty =:= 1 -> easyAiMove;
hardAiMove).

easyAiMove:-
random(1,5,RowAI),
random(1,5,ColAI),
board(Board),
(checkMove(RowAI, ColAI, Board, 1, 0, 0)-> 
board2(Board2), putMove(RowAI, ColAI, Board, Board2, 1), set_board(Board2),clearScreen, printBoard, sleep(3); 
(easyAiMove); true).

hardAiMove:- 
    checkBestMove(Row, Col, 1, Min),
    board(Board),
    board2(Board2),
    putMove(Row, Col, Board, Board2, 1),
    set_board(Board2),
    clearScreen, printBoard,
    sleep(3).

checkBestMove(Row, Col, I, Min):-
    (I =:= 5 -> checkBestMoveRow(Col, I, 1, Min), Row = 5;
    checkBestMove(Row1, Col1, I + 1, Min1),
    checkBestMoveRow(Col2, I, 1, Min2),
    (Min1 > Min2 -> Min = Min2, Row = I, Col = Col2; Min = Min1, Col = Col1, Row = Row1)
    ).

checkBestMoveRow(Col, I, J, Min):-
    board(Board),
    (\+checkMove(I, J, Board, 1, 0, 0) -> (J =:= 5 -> Min = 26; checkBestMoveRow(Col, I, J + 1, Min));
    J =:= 5 -> countOpts(I, J, Min), Col = 5;
    checkBestMoveRow(Col1, I, J + 1, Min1),
    countOpts(I, J, Min2),
    (Min1 > Min2 -> Min = Min2, Col = J; Min = Min1, Col = Col1)
    ).

countOpts(Col, Row, N):-
    board(Board),
    board2(Board2),
    putMove(Row, Col, Board, Board2, 1),
    countMoves(Board, 1, N).

countMoves([], I, N):- N is 0.

countMoves([H|T], I, N):-
    countTryRow(H, I, 1, N1),
    countMoves(T, I + 1, N2),
    N is N1 + N2.

countTryRow([], I, J, N):- N is 0.

countTryRow([H|T], I, J, N):-
    board(Board),
    (checkMove(I, J, Board, 1, 0, 0) -> N2 is 1; N2 is 0),
    countTryRow(T, I, J + 1, N1),
    N = N1 + N2.


% Input and Interface ------------------------------------------------------------------------------------------

printBoard:- board(Board), maplist(writeBoardLine, Board), nl.

writeBoardLine(L):- maplist(writeBoardChar, L), nl, nl.

writeBoardChar(C):- (C =:= 0 -> writeq(' W '); C =:= 1 -> writeq(' B '); writeq(' R ')).

writeLine(L):- writeq(L), nl.

clearScreen:- repeatNl(1).

repeatNl(0).
repeatNl(N):- N>0 ,nl, S is N-1, repeatNl(S).

playerInput:-
    writeLine('Please input your next tile'), 
    getCoord(MoveRow, 'Row:'),
    getCoord(MoveCol, 'Column:'),
    makeMove(MoveRow, MoveCol).

printWin:-
writeq('The game is over. Player '), 
color(Color),
(Color =:= 1 -> writeq('Blue'); writeq('Red')),
writeq(' wins!'), nl,
sleep(1.5),nl.