:- dynamic(moveCount/1).

resetMoveCount :-
    retractall(moveCount(_)),
    assertz(moveCount(0)).

updateMoveCount :-
   moveCount(X),
   (  X < 3 ->
      retractall(moveCount(X)),
      NewX is X + 1,
      assertz(moveCount(NewX))
      ;
      write('Anda sudah tidak bisa bergerak'),!,fail
   ).

move(X1, X2, Y) :-
    updateMoveCount,
    current_player(Player),
    player(Player, _, _), 
    region(X1, _, _, CurrentSoldiers, Player, _),
    region(X2, _, _, _, Player, _), 
    Y > 0,
    Y =< CurrentSoldiers, 
    region(X1, Continent1, Name1, TroopsX1, Player, Neighbors1),

    TroopsX1 > Y,

    retract(region(X1, Continent1, Name1, TroopsX1, Player, Neighbors1)),
    retract(region(X2, Continent2, Name2, TroopsX2, Player, Neighbors2)),

    NewTroopsX1 is TroopsX1 - Y,
    NewTroopsX2 is Y + TroopsX2,
    
    assertz(region(X1, Continent1, Name1, NewTroopsX1, Player, Neighbors1)),
    assertz(region(X2, Continent2, Name2, NewTroopsX2, Player, Neighbors2)),

    format('~w memindahkan ~d tentara dari ~w ke ~w.\n', [Player, Y, Name1, Name2]),!.  

move(_, _, 0) :-
    write('Pemindahan tidak valid.\n'),
    false.

draft(Land,Ammount):-
    current_player(ActivePlayer),
    % check army count
    player(ActivePlayer,_Dice,Troop),
    (
        Ammount > Troop ->
        write('Tentara anda tidak cukup! anda memiliki sisa '),
        write(Troop),
        write(' tentara,'),nl
        ;
        (
            region(Land, Region , Name , ArmyCount , ActivePlayer, Neighbor) ->
                retract(region(Land, Region , Name , ArmyCount , ActivePlayer, Neighbor)),
                NewArmyCount = ArmyCount + Ammount,
                assertz(region(Land, Region , Name , NewArmyCount , ActivePlayer, Neighbor)),
                write("Soldiers drafted!"),nl,
                format(' (~w) >>> (~w) ',[ArmyCount,NewArmyCount]),nl
            ;
                write('Tanah bukan milik anda!')

        ),
        !
    ).