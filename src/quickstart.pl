quickstart:-
    List = [na1,na2,na3,na4,na5,sa1,sa2,e1,e2,e3,e4,e5,a1,a2,a3,a4,a5,a6,a7,af1,af2,af3,au1,au2],
    quickpick(List).


quickpick([]):- !.
    quickpick([Head|Tail]):-
    takeLocations(Head),
    quickpick(Tail).