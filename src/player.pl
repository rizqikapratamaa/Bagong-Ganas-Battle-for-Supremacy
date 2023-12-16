continent_bonus(america_north, 3).
continent_bonus(europe, 3).
continent_bonus(asia, 5).
continent_bonus(america_south, 2).
continent_bonus(africa, 2).
continent_bonus(australia, 1).

checkPlayerTerritories(PlayerName) :-
    player(PlayerName, _, _),
    format('Nama              : ~w\n\n', [PlayerName]),
    findall(Continent, region(_, Continent, _, _, PlayerName, _), Continents),
    list_to_set(Continents, UniqueContinents),
    maplist(print_continent_territories(PlayerName), UniqueContinents).

print_continent_territories(PlayerName, Continent) :-
    findall(Region, region(Region, Continent, _, _, PlayerName, _), PlayerRegions),
    length(PlayerRegions, TotalPlayerRegions),
    findall(Region, region(Region, Continent, _, _, _, _), AllRegions),
    length(AllRegions, TotalRegions),
    format('Benua ~w (~d/~d)\n', [Continent, TotalPlayerRegions, TotalRegions]),
    maplist(print_region_details, PlayerRegions),
    nl.

print_region_details(Region) :-
    region(Region, _, Name, Troops, _, _),
    format('~w\nNama              : ~w\nJumlah tentara    : ~d\n\n', [Region, Name, Troops]).

checkPlayerDetail(PlayerName) :-
    player(PlayerName, _, AdditionalTroops),
    findall(Continent, region(_, Continent, _, _, PlayerName, _), Continents),
    list_to_set(Continents, UniqueContinents),
    join_list(', ', UniqueContinents, ContinentsStr),
    findall(Region, region(Region, _, _, _, PlayerName, _), Regions),
    length(Regions, TotalRegions),
    findall(Troops, region(_, _, _, Troops, PlayerName, _), TroopsList),
    sum_list(TroopsList, ActiveTroops),
    format('Nama                  : ~w\n', [PlayerName]),
    format('Benua                 : ~w\n', [ContinentsStr]),
    format('Total Wilayah         : ~d\n', [TotalRegions]),
    format('Total Tentara Aktif   : ~d\n', [ActiveTroops]),
    format('Total Tentara Tambahan: ~d\n', [AdditionalTroops]).

list_to_set(List, Set) :-
    list_to_set(List, [], Set).

list_to_set([], Set, Set).
list_to_set([H|T], Temp, Set) :-
    member(H, Temp), !,
    list_to_set(T, Temp, Set).
list_to_set([H|T], Temp, Set) :-
    list_to_set(T, [H|Temp], Set).

join_list(_, [], "").
join_list(_, [Last], Last).
join_list(Delimiter, [Head|Tail], Result) :-
    join_list(Delimiter, Tail, TailResult),
    atom_concat(Head, Delimiter, HeadDelimiter),
    atom_concat(HeadDelimiter, TailResult, Result).


checkIncomingTroops(PlayerName) :-
    player(PlayerName, _, _),
    findall(Region, region(Region, _, _, _, PlayerName, _), Regions),
    length(Regions, TotalRegions),
    AdditionalTroops is TotalRegions // 2,
    TotalTroops is AdditionalTroops,
    format('Nama                                    : ~w\n', [PlayerName]),
    format('Total wilayah                           : ~d\n', [TotalRegions]),
    format('Jumlah tentara tambahan dari wilayah    : ~d\n', [AdditionalTroops]),
    (
        player_controls_continent(PlayerName, north_america) ->
            write('Bonus North America                     : 3\n'),
            NewTotalTroops is TotalTroops + 3,
            TotalTroops is NewTotalTroops
        ;
            true
    ),
    (
        player_controls_continent(PlayerName, europe) ->
            write('Bonus Europe                            : 3\n'),
            NewTotalTroops is TotalTroops + 3,
            TotalTroops is NewTotalTroops
        ;
            true
    ),
    (
        player_controls_continent(PlayerName, asia) ->
            write('Bonus Asia                              : 5\n'),
            NewTotalTroops is TotalTroops + 5,
            TotalTroops is NewTotalTroops
        ;
            true
    ),
    (
        player_controls_continent(PlayerName, africa) ->
            write('Bonus Africa                            : 2\n'),
            NewTotalTroops is TotalTroops + 2,
            TotalTroops is NewTotalTroops
        ;
            true
    ),
    (
        player_controls_continent(PlayerName, australia) ->
            write('Bonus Australia                         : 1\n'),
            NewTotalTroops is TotalTroops + 1,
            TotalTroops is NewTotalTroops
        ;
            true
    ),
    (
        player_controls_continent(PlayerName, south_america) ->
            write('Bonus South America                     : 2\n'),
            NewTotalTroops is TotalTroops + 2,
            TotalTroops is NewTotalTroops
        ;
            true
    ),
    format('Total tentara tambahan                  : ~d\n', [TotalTroops]).
    

giveExtraSoldiers(Player) :-
    findall(Region, region(Region, _, _, _, Player, _), Regions),
    length(Regions, TotalRegions),
    ExtraTroops is TotalRegions // 2,
    player(Player, Dice, Troops),
    findall(Continent, region(_, Continent, _, _, Player, _), Continents),
    list_to_set(Continents, UniqueContinents),
    findall(Bonus, (member(Continent, UniqueContinents), continent_bonus(Continent, Bonus), player_controls_continent(Player, Continent)), Bonuses),
    sum_list(Bonuses, TotalBonus),
    (
        activeEffect(Player,'AUXILIARY TROOPS') ->
        NewTroops is Troops + ExtraTroops + TotalBonus + ExtraTroops + TotalBonus,
        write('[AUXILIARY TROOPS] ')
        ;
        activeEffect(Player,'SUPPLY CHAIN ISSUE') ->
        NewTroops is Troops,
        write('[SUPPLY CHAIN ISSUE] ')
        ;
        NewTroops is Troops + ExtraTroops + TotalBonus
    ),
    retract(player(Player, Dice, Troops)),
    assertz(player(Player, Dice, NewTroops)),
    GainedTroop is NewTroops - Troops,
    format('Player ~w mendapatkan ~w tentara.', [Player, GainedTroop]),nl.
    

player_controls_continent(PlayerName, Continent) :-
    findall(Region, region(Region, Continent, _, _, _, _), AllRegions),
    findall(Region, region(Region, Continent, _, _, PlayerName, _), PlayerRegions),
    sort(AllRegions, SortedAllRegions),
    sort(PlayerRegions, SortedPlayerRegions),
    SortedAllRegions == SortedPlayerRegions.

player_loses(PlayerName) :-
    retract(player_list(Players)),
    delete(Players, PlayerName, NewPlayers),
    assertz(player_list(NewPlayers)).
    
check_player_elimination(Defender) :-
    count_player_regions(Defender, TotalRegions),
    (
        TotalRegions =:= 0 ->
            retractall(player(Defender, _, _)),
            player_loses(Defender),
            format('Jumlah wilayah Player ~w 0.\n', [Defender]),
            format('Player ~w keluar dari permainan!\n', [Defender])
        ; true
    ).

check_game_winner :-
    findall(Player, player(Player, _, _), Players),
    all_regions_taken,
    length(Players, TotalPlayers),
    (
        TotalPlayers =:= 1 ->
            findall(Player, player(Player, _, _), [Winner]),
            format('\n******************************\n*~w telah menguasai dunia*\n******************************\n', [Winner])
        ; true
    ).

count_player_regions(PlayerName, TotalRegions) :-
    findall(Region, region(Region, _, _, _, PlayerName, _), Regions),
    length(Regions, TotalRegions).
    