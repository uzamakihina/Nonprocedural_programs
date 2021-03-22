% By Joe Xu
% 1472886
% CMPUT 325 section B1
% Assighnmnet 3

% QUESTION1.

% My member function
memberX(X, [First|_]):-
    X = First.
memberX(X, [_|Rest]):-
    memberX(X,Rest).  

% Base cases
setIntersect(_, [], []).
setIntersect([], _, []).

% If the first element in first list is not in the second list move to second element
setIntersect([S1first| S1Rest], S2, A) :- 
    \+ memberX(S1first, S2), ! ,
    setIntersect(S1Rest, S2, A).

% else add first element into return list and move to the next case.
setIntersect([S1first| S1Rest], S2, [S1first|A]) :- 
    setIntersect(S1Rest, S2, A).


% QUESTION2.
% base case
swap([],[]).

% return if there is only 1 item in list else swap and go to the rest of the list.
swap([First|Rest], [First]) :- Rest == [].
swap([First, Second |Rest], [Second, First| Ret]) :- swap(Rest, Ret).


% QUESTION3.
% base case
filter([], _, _, []).

% handles if first is greater than N
filter([First | Rest], OP, N, [First | Ansr]):- OP = greaterThan, 
    number(First),
    First > N, filter(Rest, OP, N, Ansr), !.

% if not move to the next 
filter([First | Rest], OP, N, Ans):- OP = greaterThan,
    number(First),
    filter(Rest, OP, N, Ans), !.

% handles if first is equal to N
filter([First | Rest], OP, N, [First | Ansr]):- OP = equal, 
    number(First),
    First =:= N, filter(Rest, OP, N, Ansr), !.

% if not move to the next 
filter([First | Rest], OP, N, Ans):- OP = equal, 
    number(First),
    filter(Rest, OP, N, Ans), !.

% handles if first is less than N
filter([First | Rest], OP, N, [First | Ansr]):- OP = lessThan, 
    number(First),
    First < N, filter(Rest, OP, N, Ansr), !.

% if not move to the next 
filter([First | Rest], OP, N, Ans):- OP = lessThan, 
    number(First),
    filter(Rest, OP, N, Ans).

% call itself on first and Rest and append the lists together
filter([First|Rest] , OP, N, Ans) :- 
    filter(First, OP, N, Fans),
    filter(Rest, OP, N, Rans), 
    append(Fans, Rans, Ans), !.


% QUESTION4

% If X in Y
in(X,[First| _]) :- X = First, !.
in(X,[_| Rest]) :- in(X, Rest), !.

% get only unique members in a list
getUnique([First |[]],  [First]).
% If first not in rest then it is unique
getUnique([First | Rest], [First | Ans]) :-
    \+ in(First, Rest), !, getUnique(Rest , Ans).
% It exists in the rest of the list
getUnique([_ |Rest],  Ans) :-
    getUnique(Rest , Ans).

% Count how many times X is in the list
countOne([], _, 0).
countOne([First| Rest], X, Num) :- 
    First = X,
    countOne(Rest, X, RCount),
    Num is 1 + RCount.
countOne([_| Rest], X, Num) :- 
    countOne(Rest,X,Num).

% build pairs [X,Y] such that X is the frequency of Atom Y in L
buildPairs([], _, []).
buildPairs([VFirst | VRest], L, [[ Count, VFirst] | Rest]) :-
    countOne(L, VFirst, Count),
    buildPairs(VRest, L, Rest), !.

% Reverse each pair in the list
rev([],[]).
rev([First | Rest], [Reversed| Rest2]) :-
    swap(First, Reversed),
    rev(Rest, Rest2), !.

countAll(L,X) :-
    getUnique(L, Uniques),
    buildPairs(Uniques, L, Pairs),
    sort(Pairs, Sorted),
    rev(Sorted, X), !.



% QUESTION5

% Base case if Atom is not found in replace list replace it with itself
findReplacement(Atom, [], Atom).

% find the replacement for Atom in the replacement list
findReplacement(Atom, [[Tosub, Sub] | _], Sub  ):-
    Atom = Tosub, !.
findReplacement(Atom, [_ | Rest] , Sub) :-
    findReplacement(Atom, Rest, Sub).

% base case 
sub([],_,[]).

% If First is atomic find its replacement in S and replace it then move to the next in the list
sub([First | Rest], S, [Front | Rest2]) :- 
    atomic(First),
    findReplacement(First, S, Front),
    sub(Rest,S, Rest2 ), !.
    
% If first is a list call sub on the First and Rest and return them as a list.
sub([First | Rest], S, [Front | Rest2]) :- 
    sub(First,S,Front),
    sub(Rest,S,Rest2), !.



% QUESTION6

% get subsets of a List as defined in the assighnment
mysubset([], _).
mysubset([X|Xs], Set) :-
  append(_, [X|Set1], Set),
  mysubset(Xs, Set1).

% remove error messages for uninitialized variables
:- dynamic([edge/2, node/1]).

% get all Nodes and for each subset of nodes check if they form a clique
clique(L) :- findall(X,node(X),Nodes), !,
    mysubset(L,Nodes),
    allConnected(L).

% check if the First element in a List has an edge between each node in the Rest of the list.
% Then call itself with Rest being the input.
allConnected([]).
allConnected([_]) :- !.
allConnected([First|Rest]):-
    findEdges(First, Rest),
    allConnected(Rest) , !.

% Base case
findEdges(_,[]).
% Check if there is an edge between A and First item in the List.
% if so move on to the next item in the list
findEdges(A, [First | Rest]):- 
    edge(A,First),
    findEdges(A, Rest), !.

% check if there is an edge between the First itme in the list to A. if so move to the next item in the list
findEdges(A, [First | Rest]):- 
    edge(First,A),
    findEdges(A, Rest), !.



% QUESTION7
:- use_module(library(lists)).

% use convert helper where the second parameter tells if the call is in conversion mode or not.
% where 0 means converting and 1 is not converting.
convert(L,R):-
    convert_helper(L,0,R).

% base case
convert_helper([],_,[]).

% if First is not q and we are not converting then ignore all conversions
convert_helper([First|Rest],In, [First|Ret]):-
    \+ First = q,
    In = 1,
    convert_helper(Rest, In, Ret), !.

% if converting and empty, then remove empty
convert_helper([First|Rest],In, Ret):-
    In = 0,
    First = e,
    convert_helper(Rest,In, Ret), !.

% if not q and in conversion mode, convert the char to c
convert_helper([First|Rest], In, [c|Ret]):-
    In = 0,
    \+ First = q,
    convert_helper(Rest,In, Ret) , !.

% If First is a Q
% if there is another q after this q and we are not in conversion mode, go to conversion mode
% and move to rest of list.
convert_helper([_|Rest],In, [q|Ret]):-
    In = 0,
    member(q, Rest),
    convert_helper(Rest,1, Ret), !.

% if there is no matching q then move on to the rest of the list while converting
convert_helper([_|Rest],In, [q|Ret]):-
    In = 0,
    \+ member(q, Rest),
    convert_helper(Rest,0, Ret), !.

% if we are already in conversion mode, exit conversion mode and move to next.
convert_helper([_|Rest],In, [q|Ret]):-
    In = 1,
    convert_helper(Rest, 0, Ret).


