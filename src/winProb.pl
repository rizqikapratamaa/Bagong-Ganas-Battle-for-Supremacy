% Predikat untuk menghitung probabilitas munculnya skor dari N lemparan dadu
probability_n_throws(TotalScore, N, Probability) :-
    MaxScore is 6 * N,
    between(N, MaxScore, TotalScore), % Total skor bisa antara N hingga MaxScore
    count_ways_to_get_score(TotalScore, N, Ways), % Hitung cara mendapatkan skor tertentu dari N lemparan
    TotalWays is 6^N, % Total cara lempar dadu adalah 6^N
    Probability is Ways / TotalWays. % Probabilitas = Cara/CaraTotal

% Predikat untuk menentukan apakah X > Y
x_greater_than_y(X, Y) :- X > Y.

% Aturan untuk menghitung probabilitas kemenangan Player 1 dengan N lemparan
calculate_win_probability(N, P) :-
    NextN is N - 1,
    probability_n_throws(_, N, Px),
    probability_n_throws(_, NextN, Py),
    findall(Pxy, (probability_n_throws(X, N, Px), probability_n_throws(Y, NextN, Py), x_greater_than_y(X, Y), Pxy is Px * Py), List),
    sum_list(List, P). % Jumlahkan semua probabilitas yang sesuai


% Hitung cara mendapatkan skor tertentu dari jumlah lemparan dadu
count_ways_to_get_score(0, 0, 1).
count_ways_to_get_score(TotalScore, NumThrows, Ways) :-
    NumThrows > 0,
    between(1, 6, DieResult),
    RemainingThrows is NumThrows - 1,
    RemainingScore is TotalScore - DieResult,
    count_ways_to_get_score(RemainingScore, RemainingThrows, SubWays),
    Ways is SubWays.

show_attack_probabilities(_Player, _FromRegion, []).
show_attack_probabilities(Player, FromRegion, [Neighbor | Rest]) :-
    region(FromRegion, _, _, Soldiers, _, _),
    probability_to_attack(Player, Soldiers, FromRegion, Neighbor, Probability),
    (format('~w: ~w% win chance\n', [Neighbor, Probability]), show_attack_probabilities(Player, FromRegion, Rest)).

probability_to_attack(Player, TroopsSent, FromRegion, ToRegion, Probability) :-
    calculate_win_probability(TroopsSent, WinProbability),
    (can_attack(Player, FromRegion, ToRegion) -> Probability = WinProbability; Probability = 0).

show_attack_probabilities(Player, FromRegion, Neighbors), nl, nl,