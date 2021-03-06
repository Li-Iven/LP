## Отчет по лабораторной работе №2
## по курсу "Логическое программирование"

## Решение логических задач

### студент: Ивенкова Л.В.

## Результат проверки

| Преподаватель     | Дата         |  Оценка       |
|-------------------|--------------|---------------|
| Сошников Д.В. |              |               |
| Левинская М.А.|              |      5        |

> *Комментарии проверяющих (обратите внимание, что более подробные комментарии возможны непосредственно в репозитории по тексту программы)*


## Введение


Логические задачи удобно решать на языке Prolog, так как на нем просто писать и понимать условия для них и легко организовывать перебор решений.

Подходов к решению логических задач может быть несколько:

1) Существуют задачи, где даётся список фактов, которые просто надо увязать между собой (например задача Эйнштейна).

2) Есть также задачи, которые решаются с помощью генерации всех возможных решений и их последующей проверки. (часто это бывают задачи, в условиях которых встречается "если ... , то ...").  

Кроме того логические задачи на языке Prolog удобно решать с использованием отсечения "!": оно помогает отбросить неверные решения и сократить перебор.

## Задание

6 человек, назовем их А, Б, В, Г, Д и Е, -  кандидаты на посты председателя, заместителя председателя и секретаря правления общества любителей логических задач. Но определить состав этой тройки оказалось не так-то легко.

Судите сами:   
1) А не хочет входить в состав руководства, если Д не будет председателем.
2) Б не хочет входить в состав руководства, если ему придется быть старшим над В.
3) Б не хочет работать вместе с Е ни при каких условиях.
4) В не хочет работать, если в состав руководства войдут Д и Е вместе.
5) В не будет работать, если Е будет председателем, или если Б будет секретарем.
6) Г не будет работать с В или Д, если ему придется подчиняться тому или другому.
7) Д не хочет быть заместителем председателя.
8) Д не хочет быть секретарем, если в состав руководства войдет Г.
9) Д не хочет работать вместе с А, если Е не войдет в состав руководства.
10) Е согласен работать только в том случае, если председателем будет либо он, либо В.

Как они решили эту проблему?

(Я пронумеровала желания людей, чтобы в них было проще ориентироваться.)

## Принцип решения

В программе я использую список должностей людей: 

```prolog
Positions = [chairman, deputy, secretary, ordinary, ordinary, ordinary]
```

Где chairman - председатель, deputy - заместитель председателя, secretary - секретарь, ordinary - обычные люди.

Также для простоты кода я заменила буквы [А,Б,В,Г,Д,Е] на [A,B,V,G,D,E] соответственно.

1) В начале я генерирую все возможные решения с помощью предиката my_permute (в предикате pre_solve):

   ```prolog
   my_permute([A,B,V,G,D,E], Positions)
   ```

   (ordinary был включён в список должностей три раза как раз ради того, чтобы предикат my_permute нормально работал - генерировал решения с тремя обычными людьми, и с тремя людьми из администрации).

2) Затем я реализую каждое из заданных 10 условий:

   ```prolog
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
   ```

   Здесь строки 
   ```prolog
   wish(_,_,_,_,_,_).
   ```

   означают, что в случаях, не описанных в наших условиях мы считаем, что этот предикат верен.

3) Затем  проверяю сгенерированные решения на соответствие этим условиям:

   ```prolog
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
   ```
   
4) Но при такой записи у нас решение может вывестись несколько раз. Поэтому реализуем ещё один предикат отбора различных решений (на основе setof):
   
   ```prolog
   solve() :- 
    setof([A,B,V,G,D,E], pre_solve([A,B,V,G,D,E]), [[X,Y,Z,O,P,U]]),  
    ...
    ```
5) Затем выводим все решения (у нас оно получится одно) в этом же предикате solve:
 
   ```prolog
    ... ,
   write("A: "), write(X), nl,
   write("Б: "), write(Y), nl,
   write("В: "), write(Z), nl,
   write("Г: "), write(O), nl,
   write("Д: "), write(P), nl,
   write("Е: "), write(U), nl.
   ```
6) Получаем ответ:

   ```prolog
   А: ordinary
   Б: deputy
   В: chairman
   Г: ordinary
   Д: secretary
   Е: ordinary
   ```

## Анализ эффективности, безопасности, непротиворечивости решения и его сложности

1) Эффективность.
   По возможности я старалась избежать больших переборов. Это мне удалось везде, кроме реализаций желаний 2 и 6, так как там нужно определять кто старше/младше по должности. А это можно сделать лишь перербрав все возможные пары людей.

2) Безопасность - благодаря отсечению у нас нигде нет зацикливающихся ветвей.

3) Непротиворечивость решения - программа нам выводит лишь одно решение (да, без отсечения оно повторяется несколько раз, но оно одно!). И это решение действительно верное - оно удовлетворяет всем условиям.

4) И наконец сложность. В предикате pre_solve мы используем генерацию решений с помощью my_permute, который работает с факториальной сложностью O(n!). У нас my_permute перербирает списки длиной 6, так что сложность перебора будет 6!. 
   Потом у нас следует проверка пожеланий людей, каждое из которых работает в худшем случае за O(n). 
   Так что в итоге у нас получится общая сложность алгоритма - факториальная.

## Выводы

При выполнении этой лабораторной работы я изучила различные способы решения логических задач на языке Prolog, и научилась применять их на практике.   

Так же я научилась оптимизировать процесс решения задач - с помощью отсечения отбрасывать заранее неверные решения и писать условные операторы - а также научилась оценивать сложность получившегося алгоритма.

В процессе решения у меня часто возникали большие переборы, или появлялись повторяющиеся ответы.  
Первую проблему я решила, введя константу ordinary - теперь мне намного легче было реализовывать "не принадлежность" человека к администрации (не надо было три раза расписывать кем не является этот человек, всё уместилось в одной строчке).  
Вторую же проблему я решила опять с помощью отсечения.

Все эти проблемы помогли мне рассмотреть разные способы решения моей задачи и лучше разобраться в работе отсечения.


