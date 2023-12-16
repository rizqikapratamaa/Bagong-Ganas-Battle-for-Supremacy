displayPickMap :-
    region(na1, north_america, 'Canada', _TroopNa1, OwnerNa1, [na2, na3]),
    region(na2, north_america, 'America', _TroopNa2, OwnerNa2, [na1, na4]),
    region(na3, north_america, 'Mexico', _TroopNa3, OwnerNa3, [na1, na4]),
    region(na4, north_america, 'Cuba', _TroopNa4, OwnerNa4, [na2, na3]),
    region(na5, north_america, 'Greenland', _TroopNa5, OwnerNa5, [e1]),
    region(sa1, south_america, 'Brazil', _TroopSa1, OwnerSa1, [na3, sa2]),
    region(sa2, south_america, 'Argentina', _TroopSa2, OwnerSa2, [sa1, af1]),
    region(e1, europe, 'England', _TroopE1, OwnerE1, [na5, e2]), 
    region(e2, europe, 'Germany', _TroopE2, OwnerE2, [e1, e4, a1]),
    region(e3, europe, 'France', _TroopE3, OwnerE3, [e1, af1, e4]),
    region(e4, europe, 'Italy', _TroopE4, OwnerE4, [e2, e3, af2]),
    region(e5, europe, 'Greece', _TroopE5, OwnerE5, [a4]),
    region(a1, asia, 'Russia', _TroopA1, OwnerA1, [e2, a4]),
    region(a2, asia, 'China', _TroopA2, OwnerA2, [a6]),
    region(a3, asia, 'Japan', _TroopA3, OwnerA3, [a5]),
    region(a4, asia, 'Arab', _TroopA4, OwnerA4, [e5, a1, a5]),
    region(a5, asia, 'Vietnam', _TroopA5, OwnerA5, [a4, a3]),
    region(a6, asia, 'India', _TroopA6, OwnerA6, [a2, a7, au1]),
    region(a7, asia, 'Indonesia', _TroopA7, OwnerA7, [a6]),
    region(af1, africa, 'Ghana', _TroopAf1, OwnerAf1, [sa2, e3]),
    region(af2, africa, 'Egypt', _TroopAf2, OwnerAf2, [e4, af3]),
    region(af3, africa, 'South Africa', _TroopAf3, OwnerAf3, [af2]),
    region(au1, australia, 'Australia', _TroopAu1, OwnerAu1, [a6, au2]),
    region(au2, australia, 'New Zealand', _TroopAu2, OwnerAu2, [au1]),
    g_read(staticPlayerList,PList),
    playerEnum(PList,OwnerNa1, PlayerENumNa1),
    playerEnum(PList,OwnerNa2, PlayerENumNa2),
    playerEnum(PList,OwnerNa3, PlayerENumNa3),
    playerEnum(PList,OwnerNa4, PlayerENumNa4),
    playerEnum(PList,OwnerNa5, PlayerENumNa5),
    playerEnum(PList,OwnerSa1, PlayerENumSa1),
    playerEnum(PList,OwnerSa2, PlayerENumSa2),
    playerEnum(PList,OwnerE1, PlayerENumE1),
    playerEnum(PList,OwnerE2, PlayerENumE2),
    playerEnum(PList,OwnerE3, PlayerENumE3),
    playerEnum(PList,OwnerE4, PlayerENumE4),
    playerEnum(PList,OwnerE5, PlayerENumE5),
    playerEnum(PList,OwnerA1, PlayerENumA1),
    playerEnum(PList,OwnerA2, PlayerENumA2),
    playerEnum(PList,OwnerA3, PlayerENumA3),
    playerEnum(PList,OwnerA4, PlayerENumA4),
    playerEnum(PList,OwnerA5, PlayerENumA5),
    playerEnum(PList,OwnerA6, PlayerENumA6),
    playerEnum(PList,OwnerA7, PlayerENumA7),
    playerEnum(PList,OwnerAf1, PlayerENumAf1),
    playerEnum(PList,OwnerAf2, PlayerENumAf2),
    playerEnum(PList,OwnerAf3, PlayerENumAf3),
    playerEnum(PList,OwnerAu1, PlayerENumAu1),
    playerEnum(PList,OwnerAu2, PlayerENumAu2),
    write('#################################################################################################'), nl,
    write('#         North America         #        Europe         #                 Asia                  #'), nl, 
    write('#                               #                       #                                       #'), nl, 
    format('#       [NA1(~w)]-[NA2(~w)]       #                       #                                       #', [PlayerENumNa1, PlayerENumNa2]), nl,
    format('-----------|       |----[NA5(~w)]----[E1(~w)]-[E2(~w)]----------[A1(~w)] [A2(~w)] [A3(~w)]-----------', [PlayerENumNa5, PlayerENumE1, PlayerENumE2, PlayerENumA1, PlayerENumA2, PlayerENumA3]), nl,
    format('#       [NA3(~w)]-[NA4(~w)]       #       |       |       #        |       |       |              #', [PlayerENumNa3, PlayerENumNa4]), nl,
    format('#          |                    #    [E3(~w)]-[E4(~w)]    ####     |       |       |              #', [PlayerENumE3, PlayerENumE4]), nl,
    format('###########|#####################       |       |-[E5(~w)]-----[A4(~w)]----+----[A5(~w)]           #', [PlayerENumE5, PlayerENumA4, PlayerENumA5]), nl,
    write('#          |                    ########|#######|###########             |                      #'), nl,
    format('#       [SA1(~w)]                #       |       |          #             |                      #', [PlayerENumSa1]), nl,
    format('#          |                    #       |    [AF2(~w)]      #         [A6(~w)]---[A7(~w)]          #', [PlayerENumAf2, PlayerENumA6, PlayerENumA7]), nl,
    format('#   |---[SA2(~w)]---------------------[AF1(~w)]---|          #             |                      #', [PlayerENumSa2, PlayerENumAf1]), nl,
    write('#   |                           #               |          ##############|#######################'), nl,
    format('#   |                           #            [AF3(~w)]      #             |                      #', [PlayerENumAf3]), nl,
    format('----|                           #                          #          [AU1(~w)]---[AU2(~w)]-------', [PlayerENumAu1, PlayerENumAu2]), nl,
    write('#                               #                          #                                    #'), nl,
    write('#       South America           #         Africa           #          Australia                 #'), nl,
    write('#################################################################################################'),
    nl,!, 
    displayEnum,
    true.

playerEnum(PList,Owner,Result):-
    (Owner == 0 ->
        Result = '_'
        ;
        ENum = ['A','B','C','D'],
        indexOfElmt(Owner,PList,PlayerID),
        getElmt(PlayerID,ENum,Result)
    ),!.
    
displayEnum:-
    !,
    g_read(staticPlayerList,PList),
    getElmt(0 ,PList, P1),
    (P1 \== 'NULL' ->
        format('A : ~w ', [P1]),nl
    ;
        write(' ')
    ),
    getElmt(1 ,PList, P2),
    (P2 \== 'NULL' ->
        format('B : ~w ', [P2]),nl
    ;
        write(' ')
    ),
    getElmt(2 ,PList, P3),
    (P3 \== 'NULL' ->
        format('C : ~w ', [P3]),nl
    ;
        write(' ')
    ),
    getElmt(3 ,PList, P4),
    (P4 \== 'NULL' ->
        format('D : ~w ', [P4]),nl
    ;
        write(' ')
    ),true.