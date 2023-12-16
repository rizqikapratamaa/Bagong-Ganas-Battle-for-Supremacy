endTurn :-
    player_list([LastPlayer|_]),
    format('Player ~w mengakhiri giliran.\n', [LastPlayer]),nl,
    next_player,
    current_player(CurrentPlayer),
    giveExtraSoldiers(CurrentPlayer),
    updateRisk(CurrentPlayer),
    resetMoveCount,
    assertz(risk_token),
    assertz(attack_token).

bonus_continents(Player, Bonus) :-
    findall(Bonus, (continent_bonus(_, Bonus), player_controls_continent(Player)), Bonuses),
    sum_list(Bonuses, Bonus).

%udah ada di player.pl
%continent_bonus(america_north, 3).
%continent_bonus(europe, 3).
%continent_bonus(asia, 5).
%continent_bonus(america_south, 2).
%continent_bonus(africa, 2).
%continent_bonus(australia, 1).

player_controls_continent(Player) :-
    continent_bonus(Continent, _),
    player_controls_all_regions_in_continent(Player, Continent).

player_controls_all_regions_in_continent(Player, Continent) :-
    findall(_, (region(_, Continent, _, _, Player, _), Player \== 0), Regions),
    region_count_in_continent(Continent, TotalRegions),
    length(Regions, TotalRegions).

region_count_in_continent(Continent, Count) :-
    findall(_, region(_, Continent, _, _, _, _), Regions),
    length(Regions, Count).