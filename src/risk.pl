:- dynamic(activeEffect/2). % player, effect
:- dynamic(risk_token/0).

random_member(Result,List):-
    length(List,X),
    random(0,X,Get),
    getElmt(Get,List,Result).

% Fungsi untuk mengambil kartu Risk secara acak
draw_risk_card(Card) :-
    RiskCards = ['CEASEFIRE ORDER', 'SUPER SOLDIER SERUM', 'AUXILIARY TROOPS', 'REBELLION', 'DISEASE OUTBREAK', 'SUPPLY CHAIN ISSUE'],
    random_member(Card, RiskCards). % roll random effect

% Fungsi untuk mengeksekusi efek dari kartu Risk
execute_risk_effect(Player, 'CEASEFIRE ORDER') :-
    assertz(activeEffect(Player,'CEASEFIRE ORDER')),
    write('Hingga giliran berikutnya, wilayah pemain tidak dapat diserang oleh lawan.\n').

% Menandai pemain mendapatkan efek Super Soldier Serum
execute_risk_effect(Player, 'SUPER SOLDIER SERUM') :-
    assertz(activeEffect(Player,'SUPER SOLDIER SERUM')), % assertz(super_soldier_serum(Player)), 
    write('Hingga giliran berikutnya, semua hasil lemparan dadu saat penyerangan dan pertahanan akan bernilai 6.\n').

execute_risk_effect(Player, 'AUXILIARY TROOPS') :-
    % retract(player(Player, _, Troops)),
    % NewTroops is Troops * 2,
    % assertz(player(Player, 0, NewTroops)),
    assertz(activeEffect(Player, 'AUXILIARY TROOPS')),
    write('Pada giliran berikutnya, tentara tambahan yang didapatkan pemain akan bernilai 2 kali lipat.\n').

execute_risk_effect(Player, 'REBELLION') :-
    findall(Region, region(Region, _, _, _, Player, _), PlayerRegions),
    random_member(RebelRegion,PlayerRegions),
    retract(region(RebelRegion, Continent, Name, Soldiers, Player, Neighbors)),
    random_player(Player,NewPlayer),
    assertz(region(RebelRegion, Continent, Name, Soldiers, NewPlayer, Neighbors)),!,
    write('Pemberontakan terjadi! Wilayah '), write(Name), write(' berpindah kekuasaan menjadi milik lawan.\n'),
    check_player_elimination(Player),
    check_game_winner.

% efek Disease Outbreak
execute_risk_effect(Player, 'DISEASE OUTBREAK') :-
    % assertz(disease_outbreak), % efek Disease Outbreak
    assertz(activeEffect(Player, 'DISEASE OUTBREAK')),
    write('Hingga giliran berikutnya, semua hasil lemparan dadu saat penyerangan dan pertahanan akan bernilai 1.\n').

% efek Supply Chain Issue
execute_risk_effect(Player, 'SUPPLY CHAIN ISSUE') :-
    % assertz(supply_chain_issue), 
    assertz(activeEffect(Player, 'SUPPLY CHAIN ISSUE')),
    write('Pada giliran berikutnya, pemain tidak mendapatkan tentara tambahan.\n').

% Fungsi utama untuk Risk
risk :-
    (
        risk_token ->
        true,
        retractall(risk_token)
        ;
        !,write('Anda sudah menggunakan risk...'),fail
    ),
    draw_risk_card(Card),
    current_player(CurrentPlayer),
    write('Player '), print_current_player_name, format(' mendapatkan risk card ~w.\n', [Card]),
    execute_risk_effect(CurrentPlayer,Card),!.
    % random_permutation([execute_risk_effect(Player, Card)], _).

% get random player name :-

random_player(ExceptPlayer,SelectedPlayer):-
    player_list(X),
    length(X,PCount),
    Max is PCount + 1,
    random(1,Max,Selected),
    getElmt(Selected,X,Result),
    (
        Result \== ExceptPlayer ->
            SelectedPlayer = Result
        ;
        random_player(ExceptPlayer,SecondResult),
        SelectedPlayer = SecondResult
    ).

% update risk
updateRisk(Player):-
    retractall(activeEffect(Player,_)).

% Fungsi untuk mengecek apakah pemain mendapatkan efek Super Soldier Serum
super_soldier_serum(Player) :-
    player(Player, _, _),
    retract(super_soldier_serum(Player)), !.
super_soldier_serum(_).

random_permutation([], []).
random_permutation(List, [X|Xs]) :-
    delete_one(X, List, Rest),
    random_permutation(Rest, Xs).

delete_one(X, [X|Xs], Xs).
delete_one(X, [Y|Ys], [Y|Zs]) :-
    delete_one(X, Ys, Zs).

