:- encoding(utf8).

my_remove(X, [X|T], T). 
my_remove(X, [Y|T], [Y|Z]):- my_remove(X, T, Z).

my_permute([],[]).
my_permute(L,[X|T]):- my_remove(X,L,R),my_permute(R,T).

%% Реализация начальных условий
% 1) А не хочет входить в состав руководства, если Д не будет председателем. 
 wish1(A,_,_,_,D,_) :- D \= chairman, !, A = ordinary.
wish1(_,_,_,_,_,_).

% 2) Б не хочет входить в состав руководства, если ему придется быть старшим над В. 
wish2(_,B,V,_,_,_) :- B = chairman, V = deputy, !, fail.
wish2(_,B,V,_,_,_) :- B = chairman, V = secretary, !, fail.
wish2(_,B,V,_,_,_) :- B = deputy, V = secretary, !, fail.
wish2(_,_,_,_,_,_).

% 3) Б не хочет работать вместе с Е ни при каких условиях. 
wish3(_,B,_,_,_,E) :- E \= ordinary, !, B = ordinary.
wish3(_,_,_,_,_,_).

% 4) В не хочет работать, если в состав руководства войдут Д и Е вместе. 
wish4(_,_,V,_,D,E) :- D \= ordinary, E \= ordinary, !, V = ordinary.
wish4(_,_,_,_,_,_).

% 5) В не будет работать, если Е будет председателем, или если Б будет секретарем. 
wish5(_,_,V,_,_,E) :- E = chairman, !, V = ordinary.
wish5(_,B,V,_,_,_) :- B = secretary, !, V = ordinary.
wish5(_,_,_,_,_,_).

% 6) Г не будет работать с В или Д, если ему придется подчиняться тому или другому. 
wish6(_,_,V,G,_,_) :- V = chairman, G = deputy, !, fail.
wish6(_,_,V,G,_,_) :- V = chairman, G = secretary, !, fail.
wish6(_,_,V,G,_,_) :- V = deputy, G = secretary, !, fail.
wish6(_,_,_,G,D,_) :- D = chairman, G = deputy, !, fail.
wish6(_,_,_,G,D,_) :- D = chairman, G = secretary, !, fail.
wish6(_,_,_,G,D,_) :- D = deputy, G = secretary, !, fail.
wish6(_,_,_,_,_,_).

% 7) Д не хочет быть заместителем председателя. 
wish7(_,_,_,_,D,_) :- D = deputy, !, fail.
wish7(_,_,_,_,_,_).

% 8) Д не хочет быть секретарем, если в состав руководства войдет Г. 
wish8(_,_,_,G,D,_) :- G = chairman, D = secretary, !, fail.
wish8(_,_,_,G,D,_) :- G = deputy, D = secretary, !, fail.
wish8(_,_,_,_,_,_).

% 9) Д не хочет работать вместе с А, если Е не войдет в состав руководства. 
wish9(A,_,_,_,D,E) :- D \= ordinary, A \= ordinary, E = ordinary, !, fail.
wish9(_,_,_,_,_,_).

% 10) Е согласен работать только в том случае, если председателем будет либо он, либо В. 
wish10(_,_,V,_,_,E) :- E = deputy, V \= chairman, !, fail.
wish10(_,_,V,_,_,E) :- E = secretary, V \= chairman, !, fail.
wish10(_,_,_,_,_,_).


%% Предикат генерации решений и их проверки
pre_solve([A,B,V,G,D,E]) :- 
    Positions = [chairman, deputy, secretary, ordinary, ordinary, ordinary],
    my_permute([A,B,V,G,D,E], Positions),
    wish1(A,B,V,G,D,E),
    wish2(A,B,V,G,D,E),
    wish3(A,B,V,G,D,E),
    wish4(A,B,V,G,D,E),
    wish5(A,B,V,G,D,E),
    wish6(A,B,V,G,D,E),
    wish7(A,B,V,G,D,E),
    wish8(A,B,V,G,D,E),
    wish9(A,B,V,G,D,E),
    wish10(A,B,V,G,D,E).

%% Предикат отбора всех различных решений и их вывода
solve() :- 
    setof([A,B,V,G,D,E], pre_solve([A,B,V,G,D,E]), [[X,Y,Z,O,P,U]]), 
    write("A: "), write(X), nl,
    write("Б: "), write(Y), nl,
    write("В: "), write(Z), nl,
    write("Г: "), write(O), nl,
    write("Д: "), write(P), nl,
    write("Е: "), write(U), nl.
