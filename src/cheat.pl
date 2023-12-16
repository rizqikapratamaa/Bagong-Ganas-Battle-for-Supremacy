shiftplayer(_Target):- current_player(_Target),!.
shiftplayer(_Target):-
    retract(player_list([FirstPlayer|RestPlayers])),
    append(RestPlayers, [FirstPlayer], NewPlayerList),
    assertz(player_list(NewPlayerList)),
    set_current_player(NewPlayerList).
    shiftplayer(_Target).

cheatMenu:-
    current_player(ActivePlayer),
    write('What is your command, '),write(ActivePlayer),write('?'),nl,
    write('1. Summon golem soldiers - Add soldiers'),nl,
    write('2. Hymne of Triumph - Instantly get land'),nl,
    write('3. Reality flux - Activate risk card'),nl,
    write('4. Song of time - Skip to another players turn (doesnt update risk)'),nl,
    write('5. Alter reality - Modify a states army ammount '),nl,
    write('6. Eidolos backtrack - Reset Move Count, Attack token, and Risk token'),nl,
    read(Choice),
    cheat(Choice).

cheat(1):- !,
    current_player(ActivePlayer),
    write('Specify the ammount of soldiers to manifest :'),
    read(Ammount),
    retract(player(ActivePlayer,_Dice,Troop)),
    NewTroop = Troop + Ammount,
    assertz(player(ActivePlayer,_Dice,NewTroop)),
    format('Done, army increased ((~d) >>> (~d))',[Troop,NewTroop]).

cheat(2):- !,
    current_player(ActivePlayer),
    write('Specify land to gain :'),
    read(Land),
    (region(Land, Continent, Name, Soldiers, Owner, Neighbors) ->
        (Owner \== ActivePlayer ->
            retract(region(Land, Continent, Name, Soldiers, Owner, Neighbors)),
            assertz(region(Land, Continent, Name, Soldiers, ActivePlayer, Neighbors)),
            write('The hymne was sung and the people now kneel before you...'),nl,
            check_player_elimination(Owner),
            check_game_winner
            ;
            write('The hymne was sung but it was a familiar tune for them...'),nl
        )
    ;
    write('The hymne was sung but there were no ears...'),nl
    ).

cheat(3):- !,write('Choose risk card to activate :'),nl,
    current_player(ActivePlayer),
    % 'CEASEFIRE ORDER', 'SUPER SOLDIER SERUM', 'AUXILIARY TROOPS', 'REBELLION', 'DISEASE OUTBREAK', 'SUPPLY CHAIN ISSUE'
    write('1. Ceasefire order'),nl,
    write('2. Super soldier serum'),nl,
    write('3. Auxiliary troops'),nl,
    write('4. Rebellion'),nl,
    write('5. Disease outbreak'),nl,
    write('6. Supply chain issue'),nl,
    read(RiskChoice),
    (
        RiskChoice == 1 ->
            execute_risk_effect(ActivePlayer,'CEASEFIRE ORDER')
        ;
        RiskChoice == 2 ->
            execute_risk_effect(ActivePlayer,'SUPER SOLDIER SERUM')
        ;
        RiskChoice == 3 ->
            execute_risk_effect(ActivePlayer,'AUXILIARY TROOPS')
        ;
        RiskChoice == 4 ->
            execute_risk_effect(ActivePlayer,'REBELLION')
        ;
        RiskChoice == 5 ->
            execute_risk_effect(ActivePlayer,'DISEASE OUTBREAK')
        ;
        RiskChoice == 6 ->
            execute_risk_effect(ActivePlayer,'SUPPLY CHAIN ISSUE')
        ;
        write('Cannot form reality into the unreal...'),nl
    )
    .

cheat(4):- !,
    player_list(PList),
    write('Current turn list : '),write(PList),nl,
    write('Skip time until whos turn? : '),
    read(Target),
    (player(Target,_Dice,_Troops) ->
        shiftplayer(Target),nl,
        write('Time passes... it is now '),write(Target),write('s turn...'),nl
        ;
        write('For a moment time stopped, trying to reach unexistance...'),nl
    ).

cheat(5):- !,
    write('Choose a location to affect : '),
    read(Land),
    (region(Land, Continent, Name, Soldiers, Owner, Neighbors) ->
        format('Change the ammount of troops (currently (~d)) : ',Soldiers),
        read(NewSoldiers),
        retract(region(Land, Continent, Name, Soldiers, Owner, Neighbors)),
        assertz(region(Land, Continent, Name, NewSoldiers, Owner, Neighbors)),
        write('Reality altered, with fate soon to follow...'),nl
        ;
        write('Unable to alter, out of existence...'),nl
    ).

cheat(6):- !,
    write('They shall fear your name...'),nl,
    resetMoveCount,
    ( \+ attack_token ->
        assertz(attack_token)
        ;
        true
    ),
    ( \+ risk_token ->
        assertz(risk_token)
        ;
        true
    ).