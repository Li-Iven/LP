% факты, описывающие возможные способы перестановки двух предметов мебели
st([space,B,C,D,E,F],[B,space,C,D,E,F]).
st([A,space,C,D,E,F],[A,C,space,D,E,F]).
st([A,B,C,space,E,F],[A,B,C,E,space,F]).
st([A,B,C,D,space,F],[A,B,C,D,F,space]).
st([space,B,C,D,E,F],[D,B,C,space,E,F]).
st([A,space,C,D,E,F],[A,E,C,D,space,F]).
st([A,B,space,D,E,F],[A,B,F,D,E,space]).

% предикат, говорящий что предметы A и B можно поменять местами
move(A,B) :- 
    st(A,B);
    st(B,A).

% продление пути
prolong([Temp|Tail],[New,Temp|Tail]) :-
    move(Temp,New),
    not(member(New, [Temp|Tail])).

% вывод результата
show_answer([_]):-!.
show_answer([A,B|Tail]):-show_answer([B|Tail]),nl,write(B),write(' -> '),write(A).

% основной предикат поиска в глубину
search_dpth(Start,Finish) :- dpth([Start],Finish,Way), show_answer(Way).
% рекурсивный поиск в глубину
dpth([Finish|Tail],Finish,[Finish|Tail]).
dpth(TempWay,Finish,Way):-prolong(TempWay,NewWay), dpth(NewWay,Finish,Way).

% основной предикат поиска в ширину
search_bdth(Start,Finish) :- bdth([[Start]], Finish, Way), show_answer(Way).
% рекурсивный поиск в ширину
bdth([[X|T]|_], X, [X|T]).
bdth([P|QI], X, R) :- 
    findall(Z, prolong(P, Z), T),
    append(QI, T, QO), !,
    bdth(QO, X, R).
bdth([_|T], Y, L) :- bdth(T, Y, L).

% основной предикат поиска в глубину с итеративным заглублением
search_idth(Start,Finish) :- search_id(Start,Finish, Way), show_answer(Way).

search_id(Start,Finish,Path,DepthLimit) :- depth_id([Start],Finish,Path,DepthLimit).
depth_id([Finish|Tail],Finish,[Finish|Tail],0).
depth_id(Path,Finish,R,N) :- 
    N>0,
    prolong(Path,NewPath),
    N1 is N-1,
    depth_id(NewPath,Finish,R,N1).
% рекурсивный поиск в глубину с итеративным заглублением
search_id(Start,Finish,Path) :- 
    int(Limit),
    search_id(Start,Finish,Path,Limit).

% предикат, генирирующий глубину поиска от 1 и далее
int(1).
int(M) :- int(N), M is N+1.
