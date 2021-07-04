% Первая часть задания - предикаты работы со списками

%Реализация стандартных предикатов

my_length([], 0).
my_length([_|Y], N):- my_length(Y, N1), N is N1 + 1.

my_member(A, [A|_]).
my_member(A, [_|Z]):- my_member(A, Z).

my_remove(X, [X|T], T).
my_remove(X, [Y|T], [Y|Z]):- my_remove(X, T, Z).

my_append(X, [], X).
my_append(Y, [A|X], [A|Z]):- my_append(Y, X, Z).

my_permute([],[]).
my_permute(L,[X|T]):- my_remove(X,L,R),my_permute(R,T).

my_sublist(S,L):- my_append(_,L1,L),my_append(S,_,L1).

%%Удаление всех элементов списка по значению
%На основе стандартных предикатов обработки списков

remove_all(X,L,L) :- not(my_member(X, L)).
remove_all(X,L,Res) :- my_member(X,L),my_remove(X,L,L2), remove_all(X,L2,Res), !.

%Без них

delete(_, [], []):-!.
delete(X, [X|T], Res):- delete(X, T, Res), !.
delete(X, [H|T], [H|Res]):- delete(X, T, Res).

%%Слияние двух упорядоченных списков
%На основе стандартных предикатов обработки списков

insert(nil,D,bt(nil,D,nil)).
insert(bt(LT,K,RT),X,bt(Ltnew,K,RT)  ):-X=<K,insert(LT,X,Ltnew).
insert(bt(LT,K,RT),X,bt(LT,K,Rtnew)  ):-X>K,insert(RT,X,Rtnew).
ltotree([],nil).
ltotree([H|X],T):-ltotree(X,T1),insert(T1,H,T).
treetol(nil,[]).
treetol(bt(LT,K,RT),S):-treetol(LT,S1), treetol(RT,S2), my_append([K|S2],S1,S).

my_sort(L,L1):-ltotree(L,T),treetol(T,L1).

sliyanie(L1,L2,Res) :- my_append(L1,L2,L), my_sort(L,Res).

%Без них

merge_lists([], L2, L2):-!.
merge_lists(L1, [], L1):-!.
merge_lists([H1|T1], [H2|T2], [H1|Res]):- H1 < H2, !, merge_lists(T1, [H2|T2], Res).
merge_lists(L1, [H2|T2], [H2|Res]):- merge_lists(L1, T2, Res).

%Пример совместного использования предикатов, реализованных в пунктах 3 и 4
%minus - Удаляем все элементы одного списка из друогого
%no_copy - выводит список всех элементов, которые встречаются только в одном из входных списков
%(объединяет списки и удаляет оттуда элементы, которые раньше принадлежали обоим спискам)
%(списки L1 и L2 упорядоченны)

minus([],L,L).
minus([H|T],L2,Res) :- merge_lists([H|T],L2,L3), delete(H,L3,R), minus(T,R,Res).
no_copy(L1,L2,Res) :- minus(L1,L2,R1), minus(L2,L1,R2), my_append(R1,R2,Res1), my_sort(Res1,Res).


