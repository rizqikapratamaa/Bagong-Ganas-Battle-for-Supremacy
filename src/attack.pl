% cek dua wilayah bersebelahan

:- dynamic(attack_token/0).

adjacent_regions(Region1, Region2) :-
    region(Region1, _, _, _, _, Neighbors),
    member(Region2, Neighbors),!.

% cek wilayah dapat diserang
can_attack(Player, FromRegion, ToRegion) :-
    (
        attack_token ->
        true
        ;
        write('Anda sudah attack tadi!'),nl,
        fail
    ),
    region(FromRegion, _, _, _Soldiers, Player, _),
    region(ToRegion, _, _, _EnemySoldiers, EnemyPlayer, _),
    adjacent_regions(FromRegion, ToRegion),
    \+ activeEffect(EnemyPlayer,'CEASEFIRE ORDER'),
    % Attacking is Soldiers,
    % Soldiers > 1, % Setidaknya satu tentara harus tetap di wilayah asal 
    Player \== EnemyPlayer, !. % Tidak dapat menyerang wilayah yang sudah dimiliki sendiri

can_attack(_Player, _FromRegion, ToRegion) :-
    region(ToRegion, _, _, _EnemySoldiers, EnemyPlayer, _),
    activeEffect(EnemyPlayer,'CEASEFIRE ORDER'),!,
    write('Cease fire order! anda tidak bisa menyerang tempat ini!'), false.

execute_attack(Player, FromRegion, ToRegion, TroopsSent) :-
    region(FromRegion, FromContinent, FromName, FromSoldiers, Player, FromNeighbors),
    region(ToRegion, ToContinent, ToName, ToSoldiers, EnemyPlayer, ToNeighbors),
    retract(region(FromRegion, FromContinent, FromName, FromSoldiers, Player, FromNeighbors)),
    NewFromSoldiers is FromSoldiers - TroopsSent,
    assertz(region(FromRegion, FromContinent, FromName, NewFromSoldiers, Player, FromNeighbors)),
    format('~w menyerang wilayah ~w dari wilayah ~w!\n', [Player, ToName, FromName]),
    format('Player ~w menyerang!', [Player]),nl,
    attackDiceRoll(Player,TroopsSent,ResultAttack,1),
    format('TOTAL ATTACKING : ~w ',[ResultAttack]),nl,
    format('Player ~w menahan!', [EnemyPlayer]),nl,
    attackDiceRoll(EnemyPlayer,ToSoldiers,ResultDefend,1),
    format('TOTAL DEFENDING : ~w ',[ResultDefend]),nl,
    (
        ResultAttack > ResultDefend ->
            write('ATTACK SUCCESS!'),nl,
            format('Player ~w menang!',[Player]),nl,
            retract(region(ToRegion, ToContinent, ToName, ToSoldiers, EnemyPlayer, ToNeighbors)),
            assertz(region(ToRegion, ToContinent, ToName, TroopsSent, Player, ToNeighbors)),
            check_player_elimination(EnemyPlayer),
            check_game_winner
        ;
            write('DEFENDING SUCCESS!'),nl,
            format('Player ~w menang!',[EnemyPlayer]),nl
    ).
    
attackDiceRoll(_,0,0,_):- !.

attackDiceRoll(Player,ArmyCount,Result,StartIndex):-
    format("Dadu ~w : ",[StartIndex]),
    (
        activeEffect(_,'DISEASE OUTBREAK') ->
        Dice is 1,
        write('DISEASE! ')
        ;
        (
            activeEffect(Player,'SUPER SOLDIER SERUM') ->
            Dice is 6,
            write('SUPER SOLDIER! ')
            ;
            random(1, 7, Dice)
        )
    ),
    write(Dice),nl,
    NextX is StartIndex + 1,
    NextArmy is ArmyCount - 1,
    attackDiceRoll(Player,NextArmy, NewResult, NextX),
    Result is NewResult + Dice,!.

attack :-
    attack_token,!,
    show_map,
    current_player(Player),
    write('Sekarang giliran '), format('~w',[Player]), write(' untuk menyerang.\n'),
    write('Pilih wilayah untuk memulai serangan: '), read(FromRegion),
    (region(FromRegion,_,_,_,Player,Neighbors) ->
        true
        ;
        write('Wilayah bukan milikmu!')
        ,!,fail
    ),
    nl,
    write('Pilih wilayah untuk diserang: '),nl,
    write(Neighbors),nl,
    write('Target : '),
    read(ToRegion),
    (
        can_attack(Player, FromRegion, ToRegion) ->
            true
        ;
            !,fail
    ),
    region(FromRegion, _, _, Soldiers, _, _),
    write('Masukkan jumlah tentara yang akan dikirim (max '), MaxTroops is Soldiers - 1, write(MaxTroops), write('): '), read(TroopsSent),
    (
        TroopsSent > 0 ->
            (
                TroopsSent =< MaxTroops ->
                    execute_attack(Player, FromRegion, ToRegion, TroopsSent),
                    nl, 
                    % show_map,
                    retractall(attack_token)
                ;
                write('Kamu tidak bisa mengirim tentara sebanyak itu!')
            )
            ;
            write('Jumlah tidak benar!')
    ).

show_map :-
    write('/* PETA */\n'),
    findall([Code, Continent, Name, Soldiers, Owner], region(Code, Continent, Name, Soldiers, Owner, _), Regions),
    print_map(Regions).

print_map([]) :- nl.
print_map([[Code, Continent, Name, Soldiers, Owner]|Rest]) :-
    format('~w (', [Code]),
    write(Continent),
    format('): ~w (Tentara: ~w, Pemilik: ~w)\n', [Name, Soldiers, Owner]),
    print_map(Rest).