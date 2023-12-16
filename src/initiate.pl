:- dynamic(player/3).
:- dynamic(run_order/1).
:- dynamic(player_list/1).
:- dynamic(current_player/1).
:- dynamic(region/6). %region(kode, benua, nama, jumlah tentara, pemilik, tetangga)

startGame :-
    retractall(region(_, _, _, _, _, _)),
    assertz(region(na1, north_america, 'Canada', 0, 0, [na2, na3])),
    assertz(region(na2, north_america, 'America', 0, 0, [na1, na4])),
    assertz(region(na3, north_america, 'Mexico', 0, 0, [na1, na4])),
    assertz(region(na4, north_america, 'Cuba', 0, 0, [na2, na3])),
    assertz(region(na5, north_america, 'Greenland', 0, 0, [e1])),
    assertz(region(sa1, south_america, 'Brazil', 0, 0, [na3, sa2])),
    assertz(region(sa2, south_america, 'Argentina', 0, 0, [sa1, af1])),
    assertz(region(e1, europe, 'England', 0, 0, [na5, e2])),
    assertz(region(e2, europe, 'Germany', 0, 0, [e1, e4, a1])),
    assertz(region(e3, europe, 'France', 0, 0, [e1, af1, e4])),
    assertz(region(e4, europe, 'Italy', 0, 0, [e2, e3, af2])),
    assertz(region(e5, europe, 'Greece', 0, 0, [a4])),
    assertz(region(a1, asia, 'Russia', 0, 0, [e2, a4])),
    assertz(region(a2, asia, 'China', 0, 0, [a6])),
    assertz(region(a3, asia, 'Japan', 0, 0, [a5])),
    assertz(region(a4, asia, 'Arab', 0, 0, [e5, a1, a5])),
    assertz(region(a5, asia, 'Vietnam', 0, 0, [a4, a3])),
    assertz(region(a6, asia, 'India', 0, 0, [a2, a7, au1])),
    assertz(region(a7, asia, 'Indonesia', 0, 0, [a6])),
    assertz(region(af1, africa, 'Ghana', 0, 0, [sa2, e3])),
    assertz(region(af2, africa, 'Egypt', 0, 0, [e4, af3])),
    assertz(region(af3, africa, 'South Africa',  0, 0, [af2])),
    assertz(region(au1, australia, 'Australia', 0, 0, [a6, au2])),
    assertz(region(au2, australia, 'New Zealand', 0, 0, [au1])),
    write('Masukkan jumlah pemain (2 - 4): '),
    read(N),
    (
        N >= 2, N =< 4 ->
            retractall(run_order(_)),
            retractall(player(_, _, _)),
            retractall(current_player(_)),
            create_players(1, N),
            findall(Player, player(Player,_,_), Players), nl,

            roll_dice(Players), nl,
            sort_players,
            show_run_order,
            run_order(Order),
            maplist(second, Order, PlayerNames),
            create_run_order_array(PlayerNames, []),
            retractall(player_list(_)),
            assertz(player_list(PlayerNames)),
            nl,
            show_total_troops(N),
            g_assign(staticPlayerList,PlayerNames),
            nl,displayPickMap,nl,
            write('Giliran '), print_current_player_name, write(' untuk memilih wilayahnya'), nl 
        ;
        write('Silakan masukkan angka dalam rentang 2 - 4.'), nl,
        start
    ).

create_players(Current, N) :-
    Current =< N,
    format('Masukkan nama pemain ~d: ', [Current]),
    read(Player),
    (
        N is 2 ->
            assertz(player(Player, 0 ,24)),
            Next is Current + 1,
            create_players(Next, N)
        ;
        N is 3 ->
            assertz(player(Player, 0 ,16)),
            Next is Current + 1,
            create_players(Next, N)
        ;
        assertz(player(Player, 0, 12)),
        Next is Current + 1,
        create_players(Next, N)
    ).
create_players(_, _) :- !.

roll_dice(Players) :-
    roll_dice_helper(Players, [], Results),
    (   has_duplicates(Results) ->
        roll_dice(Players)
    ;   true
    ).

roll_dice_helper([], _, []).
roll_dice_helper([Player|Rest], RolledSums, [Sum-Player|Results]) :-
    random(1, 7, Dice1),
    random(1, 7, Dice2),
    Sum is Dice1 + Dice2,
    (
        member(Sum, RolledSums) ->
            roll_dice_helper([Player|Rest], RolledSums, Results)
        ;
            format('~w melempar dadu dan mendapatkan ~d.\n', [Player, Sum]),
            retract(player(Player,_,Soldiers)),
            assertz(player(Player, Sum, Soldiers)),
            roll_dice_helper(Rest, [Sum|RolledSums], Results)
    ).


has_duplicates(List) :-
    sort(List, Sorted),
    adjacent_duplicate(Sorted).

adjacent_duplicate([X, X|_]).
adjacent_duplicate([_|Rest]) :-
    adjacent_duplicate(Rest).
    
sort_players :-
    findall(Result-Player, player(Player, Result, _), Players),
    keysort(Players, SortedPlayers),
    reverse(SortedPlayers, ReversedPlayers),
    retractall(run_order(_)),
    assertz(run_order(ReversedPlayers)).
    
show_run_order :-
    run_order(Order),
    maplist(second, Order, PlayerNames),
    write('Urutan pemain: '),
    print_order(PlayerNames), nl,
    set_current_player(PlayerNames),
    print_current_player_name,
    write(' dapat mulai terlebih dahulu.').

create_run_order_array(_PlayerNames, []).

create_run_order_array([], Array) :-
    write('Array urutan pemain: '),
    write(Array), nl.

create_run_order_array([Player|Rest], CurrentArray) :-
    append(CurrentArray, [Player], NewArray),
    create_run_order_array(Rest, NewArray).

print_order([Name]) :- !, write(Name).
print_order([Name|Rest]) :-
    write(Name), write(' - '), print_order(Rest).

set_current_player([Name]) :- 
    !,
    retractall(current_player(_)),
    assertz(current_player(Name)),
    write(Name).

set_current_player([Name|_]) :-
    retractall(current_player(_)),
    assertz(current_player(Name)).

second(_-Y, Y).

show_total_troops(N) :-
    (
        N is 2 ->
            nl,
            write('Setiap pemain mendapatkan 24 tentara'), nl
        ;
        N is 3 ->
            nl,
            write('Setiap pemain mendapatkan 16 tentara'), nl
        ;
        nl,
        write('Setiap pemain mendapatkan 12 tentara'), nl
    ).

print_current_player_name :-
    findall(Name, current_player(Name), [Thename]),
    write(Thename).

takeLocation(Location) :-
    (
        all_regions_taken ->
            write('Seluruh wilayah telah diambil pemain. Tidak bisa mengambil wilayah.\n')
        ;
            current_player(Player),
            player(Player, _, Troops),
            (
                region(Location, Continent, Name, Soldiers, 0, Neighbors) ->
                    NewTroops is Troops - 1,
                    retract(player(Player, Dice, Troops)),
                    assertz(player(Player, Dice, NewTroops)),
                    NewSoldiers is Soldiers + 1,
                    retract(region(Location, Continent, Name, Soldiers, _, Neighbors)),
                    assertz(region(Location, Continent, Name, NewSoldiers, Player, Neighbors)),
                    format('~w mengambil wilayah ~w.\n', [Player, Location]),
                    (   all_regions_taken ->
                            nl,
                            write('Seluruh wilayah telah diambil pemain.\nMemulai pembagian sisa tentara.\n'),
                            next_player,
                            nl,
                            write('Giliran '), print_current_player_name, write(' untuk meletakkan tentaranya'), nl
                        ;   
                        next_player, nl, displayPickMap,
                        write('Giliran '), print_current_player_name, write(' untuk memilih wilayahnya'),nl
                    )
                ;
                region(Location, _, _, _, Owner, _), Owner \== 0 ->
                    write('Wilayah sudah dikuasai. Tidak bisa mengambil.\n')
                ;
                    write('Tidak ada wilayah dengan nama tersebut.\n')
            )
    ).
    
initializeVariables :- 
    assertz(attack_token),
    player_list([FirstPlayer|_RestPlayers]),
    resetMoveCount,
    assertz(risk_token),
    giveExtraSoldiers(FirstPlayer).

next_player :-
    retract(player_list([FirstPlayer|RestPlayers])),
    append(RestPlayers, [FirstPlayer], NewPlayerList),
    assertz(player_list(NewPlayerList)),
    set_current_player(NewPlayerList).

all_regions_taken :-
    findall(_, region(_, _, _, _, 0, _), FreeRegions),
    length(FreeRegions, NumFreeRegions),
    NumFreeRegions =:= 0.

placeAutomatic :-
    (
        all_players_done ->
            nl,displayPickMap,nl,nl,
            write('Seluruh pemain telah meletakkan tentaranya.\n'),
            true
        ;
            all_regions_taken ->
                current_player(Player),
                player(Player, _, Troops),
                (
                    Troops > 0 ->
                        findall(Location, region(Location, _, _, _, Player, _), Locations),
                        place_troops_random(Locations, Player, Troops),
                        write('Seluruh tentara '), print_current_player_name, write(' sudah diletakkan.\n'),
                        next_player,
                        (
                            all_players_done ->
                                nl,
                                write('Seluruh pemain telah meletakkan sisa tentara.\nMemulai permainan.\n'),
                                initializeVariables, % buat variabel kaya attack token
                                write('Sekarang giliran '), print_current_player_name, write('!\n'),
                                true
                            ;
                                true
                        )
                    ;
                        write('Seluruh tentara '), print_current_player_name, write(' sudah diletakkan.\n'),
                        true
                )
            ;
                write('Belum semua daerah terisi. Tidak bisa menempatkan tentara.\n')
    ),
    true.
    
    
place_troops_random(_, _, 0) :- !.
place_troops_random([], _, _).
place_troops_random([Location|Rest], Player, Troops) :-
    region(Location, Continent, Name, Soldiers, Player, Neighbors),
    X is Troops+1,
    random(1, X, Deploy),
    NewSoldiers is Soldiers + Deploy,
    NewTroops is Troops - Deploy,
    retract(region(Location, Continent, Name, Soldiers, Player, Neighbors)),
    assertz(region(Location, Continent, Name, NewSoldiers, Player, Neighbors)),
    retract(player(Player, Dice, Troops)),
    assertz(player(Player, Dice, NewTroops)),
    format('~w meletakkan ~d tentara di wilayah ~w.\n', [Player, Deploy, Location]),
    place_troops_random(Rest, Player, NewTroops).

placeTroops(Location, Amount) :-
    (
        all_players_done ->
            write('Seluruh pemain telah meletakkan tentaranya.\n'),
            true
        ;
            all_regions_taken ->
                current_player(Player),
                player(Player, _, Troops),
                (
                    Troops >= Amount, region(Location, Continent, Name, Soldiers, Player, Neighbors) ->
                        NewTroops is Troops - Amount,
                        NewSoldiers is Soldiers + Amount,
                        retract(player(Player, Dice, Troops)),
                        assertz(player(Player, Dice, NewTroops)),
                        retract(region(Location, Continent, Name, Soldiers, Player, Neighbors)),
                        assertz(region(Location, Continent, Name, NewSoldiers, Player, Neighbors)),
                        format('~w meletakkan ~d tentara di wilayah ~w.\n', [Player, Amount, Location]),
                        (
                            NewTroops > 0 ->
                                format('Terdapat ~d tentara yang tersisa.\n', [NewTroops])
                            ;
                                true
                        ),
                        (
                            NewTroops =:= 0 ->
                                write('Seluruh tentara '), print_current_player_name, write(' sudah diletakkan.\n'),
                                next_player,
                                (
                                    all_players_done ->
                                        nl,
                                        write('Seluruh pemain telah meletakkan sisa tentara.\nMemulai permainan.\n'), nl,
                                        initializeVariables,
                                        write('Sekarang giliran '), print_current_player_name, write('!\n'),
                                        true
                                    ;
                                        nl,
                                        write('Sekarang giliran '), print_current_player_name, write('!\n'),
                                        true
                                )
                            ;
                                next_player, nl,
                                write('Sekarang giliran '), print_current_player_name, write('!\n'),
                                true
                        )
                    ;
                        write('Tidak bisa meletakkan tentara.\n')
                )
            ;
                write('Belum semua daerah terisi. Tidak bisa menempatkan tentara.\n')
    ).   
    
    
all_players_done :-
    findall(Troops, player(_, _, Troops), AllTroops),
    sum_list(AllTroops, TotalTroops),
    TotalTroops =:= 0.