% some variables
countrow(S) :- string(S,X,N).
countcolumn(X) :- string(S,X,N).
maxrow(R) :- R=#max{S:countrow(S)}.
maxcolumn(C) :- C=#max{X:countcolumn(X)}.
s(1..R):- maxrow(R). 
p(1..2*R):- maxrow(R).
m(1..C) :- maxcolumn(C).
n(0..1).

same(L,I,J) :- y(I,J,N),y(L,J,N),I!=L. % Testet ob 2 Spalten identisch sind
same(L,I) :- {same(L,I,J):p(L),p(I),m(J)}=C, maxcolumn(C),p(L),p(I). % Testet ob 2 Reihen identisch sind
diff(L,I) :- y(L,J,M),y(I,J,N), not same(L,I),I!=L.
unique(L) :- y(L,J,M), {diff(L,I):p(I)}=(2*R)-1, maxrow(R). 

sameu(L,I,J) :- y(I,J,N),y(L,J,N),I>L. % Testet ob 2 Spalten identisch sind
sameu(L,I) :- {sameu(L,I,J):p(L),p(I),m(J)}=C, maxcolumn(C),p(L),p(I). % Testet ob 2 Reihen identisch sind
mer(U) :- y(L,J,N), not unique(L), U=#min{R:sameu(R,L)}.

% generate parents
y(2*I,J,0)		:-	string(I,J,0).
y((2*I)-1,J,0)		:-	string(I,J,0).

y(2*I,J,1)	:-	string(I,J,1).
y((2*I)-1,J,1)		:-	string(I,J,1).

{y((2*I)-1,J,N):n(N)}=1					:-	string(I,J,2).
{y((2*I),J,N):n(N)}=1						:-	string(I,J,2).

parent(L,X,N)			:-	unique(L),y(L,X,N).
parent(L,X,N)			:-  mer(L), y(L,X,N), L!=#sup.

% minimize

minpar(U) :- U=#count{S:parent(S,X,N)}. % Ermittle die Anzahl der Elternreihen
#minimize{U:minpar(U)}. % Gib den Minimalwert der Anzahl der Elternreihen aus

% constraints
:- string(I,J,2), y((2*I)-1,J,N),y((2*I),J,M),(M+N)!=1.		

#show parent/3.
