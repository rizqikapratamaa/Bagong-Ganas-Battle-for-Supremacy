insertFirst(Element, List, [Element|List]).

konkat([], SecondList, SecondList) :- !.
konkat([Head|Tail], SecondList, [Head|Result]) :-
    konkat(Tail, SecondList, Result).

indexOfElmt(_,[],-1):- !.
indexOfElmt(Element,[Element|_],0):- !.
indexOfElmt(Element,[Head|Tail],X):-
    Element \== Head, indexOfElmt(Element,Tail,Z), X is Z + 1.

getElmt(_,[],'NULL'):- !.
getElmt(0,[Head|_],Head):- !.
getElmt(Idx,[_Head|Tail],Item):-
    Next is Idx-1, getElmt(Next,Tail,Item).

isInList(Element,[Head|_]):-
    Element == Head,!.

isInList(Element,[_|Tail]):-
    isInList(Element,Tail).

% Return Result dimana result adalah List dengan elemen diminta pertama dari kiri, atau list sama jika tidak ada.
deleteInList(_,[],[]):-!.
deleteInList(Element,[Element|Tail],Tail):-!.
deleteInList(Element,[Head|Tail],[Head|Result]):-
    Element \== Head, deleteInList(Element,Tail,Result).