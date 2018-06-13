% Generate field
field(1..X,1..Y) :- rows(X), cols(Y).

% Identify fields with taken spaces and not taken spaces
notfree(X,Y) :- empty(X,Y).
notfree(X,Y) :- digit(X,Y,N).
freewithoutlight(X,Y) :- field(X,Y), not notfree(X,Y).
free(X,Y) :- freewithoutlight(X,Y), not light(X,Y).

% Fill some free spaces with lights
{light(X,Y)}1 :- not notfree(X,Y), field(X,Y).

% Check if there is a digit oder empty space between two lights in a row
saferowdigit(X,Y,A,Y):- light(X,Y),light(A,Y),digit(B,Y,_),X!=A,B<A,B>X.
saferowdigit(A,Y,X,Y):-saferowdigit(X,Y,A,Y).
saferowempty(X,Y,A,Y):- light(X,Y),light(A,Y),empty(B,Y),X!=A,B<A,B>X.
saferowempty(A,Y,X,Y):-saferowempty(X,Y,A,Y).
saferow(X,Y,A,Y) :-light(X,Y),light(A,Y),X!=A, saferowdigit(X,Y,A,Y), saferowempty(X,Y,A,Y).
saferow(X,Y,A,Y) :-light(X,Y),light(A,Y),X!=A, not saferowdigit(X,Y,A,Y), saferowempty(X,Y,A,Y).
saferow(X,Y,A,Y) :-light(X,Y),light(A,Y),X!=A, saferowdigit(X,Y,A,Y), not saferowempty(X,Y,A,Y).

% If there is no empty or digit space between two lights in a row, they can't exist
:- light(X,Y),light(A,Y),X!=A, not saferow(X,Y,A,Y).

% Check if there is a digit oder empty space between two lights in a column
safecolumndigit(X,Y,X,A):-light(X,Y),light(X,A),digit(X,B,_),Y!=A,B<A,B>Y.
safecolumndigit(X,A,X,Y):-safecolumndigit(X,Y,X,A).
safecolumnempty(X,Y,X,A):-light(X,Y),light(X,A),empty(X,B),Y!=A,B<A,B>Y.
safecolumnempty(X,A,X,Y):-safecolumnempty(X,Y,X,A).
safecolumn(X,Y,X,A):-light(X,Y),light(X,A),Y!=A,safecolumndigit(X,Y,X,A),safecolumnempty(X,Y,X,A).
safecolumn(X,Y,X,A):-light(X,Y),light(X,A),Y!=A,not safecolumndigit(X,Y,X,A),safecolumnempty(X,Y,X,A).
safecolumn(X,Y,X,A):-light(X,Y),light(X,A),Y!=A,safecolumndigit(X,Y,X,A), not safecolumnempty(X,Y,X,A).

% If there is no empty or digit space between two lights in a column, they can't exist
:-light(X,Y),light(X,A),Y!=A,not safecolumn(X,Y,X,A).

% Check if every free space is illuminated by a light from the same row
illumrowmore(X,Y):- free(X,Y), light(A,Y),X>A, B=A+1, T{free(B..X,Y)}T,T=X-A.
illumrowless(X,Y):- free(X,Y), light(A,Y),X<A, B=A-1, T{free(X..B,Y)}T,T=A-X.
illumrow(X,Y):-  illumrowmore(X,Y),illumrowless(X,Y).
illumrow(X,Y):-  not illumrowmore(X,Y),illumrowless(X,Y).
illumrow(X,Y):-  illumrowmore(X,Y),not illumrowless(X,Y).

% Check if every free space is illuminated by a light from the same column
illumcolumnmore(X,Y):- free(X,Y), light(X,A),Y>A, B=A+1, T{free(X,A..Y)}T,T=Y-A.
illumcolumnless(X,Y):- free(X,Y), light(X,A),Y<A, B=A-1, T{free(X,Y..B)}T,T=A-Y.
illumcolumn(X,Y):-  illumcolumnmore(X,Y),illumcolumnless(X,Y).
illumcolumn(X,Y):-  not illumcolumnmore(X,Y),illumcolumnless(X,Y).
illumcolumn(X,Y):-  illumcolumnmore(X,Y),not illumcolumnless(X,Y).

% Check if every free space is illuminated by a light from the same row or from the same column 
illum(X,Y):- illumrow(X,Y),illumcolumn(X,Y).
illum(X,Y):- not illumrow(X,Y),illumcolumn(X,Y).
illum(X,Y):- illumrow(X,Y),not illumcolumn(X,Y).

% There is no free space, which is not illuminated
noillum(X,Y):- free(X,Y), not illum(X,Y).
:- noillum(X,Y).

% Check if every space with a digit has N light neighbour, if digit(X,Y,N) applies.
neighbour(X,Y,B) :- digit(X,Y,B), B{light(X-1,Y);light(X+1,Y);light(X,Y+1);light(X,Y-1)}B.

% There is no digit(X,Y,B), which has more or less than B neighbours
:- digit(X,Y,B), not neighbour(X,Y,B).

% Output light
#show light/2.
