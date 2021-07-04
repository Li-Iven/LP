% Task 2: Relational Data

% The line below imports the data
:- encoding(utf8).
:- ['four.pl'].

my_length([], 0).
my_length([_|Y], N):- my_length(Y, N1), N is N1+1.

%сумма элементов списка

sum_list([], 0):-!.
sum_list([H|T], Sum):- sum_list(T, T1), Sum is T1 + H.

groups(X) :- member(X,[101,102,103,104]).
subjects(X) :- member(X,['Логическое программирование','Математический анализ','Функциональное программирование','Информатика','Английский язык','Психология']).

% Получить таблицу групп и средний балл по каждой из групп

student(G,X) :- group(G,L), member(X,L).
ball(X,C) :- subject(_,L2), member(grade(X,C),L2).
ball_of_student(G,C) :- student(G,X), ball(X,C).

sr_ball(G,Res) :- findall(Res, ball_of_student(G,Res), R), sum_list(R,Sum), my_length(R, Len),  Res is Sum/Len.
sr_ball_of_groups() :- groups(G), sr_ball(G,S), write("Группа: "), write(G), write("  Средний балл = "), write(S), write("\n"), fail.

% Для каждого предмета получить список студентов, не сдавших экзамен (grade=2)

no_pass(S,X) :- subject(S,C), member(grade(X,2),C).
no_pass_sub() :- subjects(S), findall(X, no_pass(S,X), Res), write("Предмет: "), write(S), write(",  Не сдали = "), write(Res), write("\n"), fail.

% Найти количество не сдавших студентов в каждой из групп

no_pass_student(G,X) :- student(G,X), ball(X,2).
no_pass_in_groups() :- groups(G), findall(X, no_pass_student(G,X), R), my_length(R, Len), write("Группа: "), write(G), write(",  Не сдали = "), write(Len), write("\n"), fail.
