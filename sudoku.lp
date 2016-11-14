%%% given multiple initial(X,Y,N) with N is the number at position x,y

% map given data into answer
sudoku(X,Y,N) :- initial(X,Y,N).
 
% Definitions
x(1..9). y(1..9). n(1..9).
{sudoku(X,Y,N): n(N)}=1 :- x(X) ,y(Y).
subgrid(X,Y,A,B) :- x(X), x(A), y(Y), y(B),(X-1)/3 == (A-1)/3, (Y-1)/3 == (B-1)/3.

% Constraints
:- sudoku(X,Y,N), sudoku(A,Y,N), X!=A.
:- sudoku(X,Y,N), sudoku(X,B,N), Y!=B.
:- sudoku(X,Y,V), sudoku(A,B,V), subgrid(X,Y,A,B), X != A, Y != B.

% Output
#show sudoku/3.
