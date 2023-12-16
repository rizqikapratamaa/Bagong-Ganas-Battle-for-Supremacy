displayMap :-
    region(na1, north_america, _, TroopsNa1, _, _),
    region(na2, north_america, _,  TroopsNa2, _, _),
    region(na3, north_america, _, TroopsNa3, _, _),
    region(na4, north_america, _, TroopsNa4, _, _),
    region(na5, north_america, _, TroopsNa5, _, _),
    region(sa1, south_america, _, TroopsSa1, _, _),
    region(sa2, south_america, _, TroopsSa2, _, _),
    region(e1, europe, _, TroopsE1, _, _),
    region(e2, europe, _, TroopsE2, _, _),
    region(e3, europe, _, TroopsE3, _, _),
    region(e4, europe, _, TroopsE4, _, _),
    region(e5, europe, _,TroopsE5, _, _),
    region(a1, asia, _, TroopsA1, _, _),
    region(a2, asia, _, TroopsA2, _, _),
    region(a3, asia, _, TroopsA3, _, _),
    region(a4, asia, _, TroopsA4, _, _),
    region(a5, asia, _, TroopsA5, _, _),
    region(a6, asia, _, TroopsA6, _, _),
    region(a7, asia, _, TroopsA7, _, _),
    region(af1, africa, _, TroopsAf1, _, _),
    region(af2, africa, _, TroopsAf2, _, _),
    region(af3, africa, _, TroopsAf3, _, _),
    region(au1, australia, _, TroopsAu1, _, _),
    region(au2, australia, _, TroopsAu2, _, _),
    write('#################################################################################################'), nl,
    write('#         North America         #        Europe         #                 Asia                  #'), nl, 
    write('#                               #                       #                                       #'), nl, 
    format('#       [NA1(~d)]-[NA2(~d)]       #                       #                                       #', [TroopsNa1, TroopsNa2]), nl,
    format('-----------|       |----[NA5(~d)]----[E1(~d)]-[E2(~d)]----------[A1(~d)] [A2(~d)] [A3(~d)]-----------', [TroopsNa5, TroopsE1, TroopsE2, TroopsA1, TroopsA2, TroopsA3]), nl,
    format('#       [NA3(~d)]-[NA4(~d)]       #       |       |       #        |       |       |              #', [TroopsNa3, TroopsNa4]), nl,
    format('#          |                    #    [E3(~d)]-[E4(~d)]    ####     |       |       |              #', [TroopsE3, TroopsE4]), nl,
    format('###########|#####################       |       |-[E5(~d)]-----[A4(~d)]----+----[A5(~d)]           #', [TroopsE5, TroopsA4, TroopsA5]), nl,
    write('#          |                    ########|#######|###########             |                      #'), nl,
    format('#       [SA1(~d)]                #       |       |          #             |                      #', [TroopsSa1]), nl,
    format('#          |                    #       |    [AF2(~d)]      #         [A6(~d)]---[A7(~d)]          #', [TroopsAf2, TroopsA6, TroopsA7]), nl,
    format('#   |---[SA2(~d)]---------------------[AF1(~d)]---|          #             |                      #', [TroopsSa2, TroopsAf1]), nl,
    write('#   |                           #               |          ##############|#######################'), nl,
    format('#   |                           #            [AF3(~d)]      #             |                      #', [TroopsAf3]), nl,
    format('----|                           #                          #          [AU1(~d)]---[AU2(~d)]-------', [TroopsAu1, TroopsAu2]), nl,
    write('#                               #                          #                                    #'), nl,
    write('#       South America           #         Africa           #          Australia                 #'), nl,
    write('#################################################################################################').

checkLocationDetail(Code) :-
    region(Code, _, Name, Soldiers, Owner, Neighbors),
    nl,
    format('Kode                  : ~w\n', [Code]),
    format('Nama                  : ~w\n', [Name]),
    (
        Owner == 0 -> write('Pemilik               : Belum Dikuasai\n')
        ;
        format('Pemilik               : ~w\n', [Owner])
    ),
    format('Total Tentara         : ~d\n', [Soldiers]),
    write('Tetangga              : '),
    print_neighbors(Neighbors), nl.

print_neighbors([]).
print_neighbors([H|T]) :-
    region(H, _, NeighborName, _, _, _),
    write(NeighborName),
    (
        T == [] -> true
        ;
        write(', '), print_neighbors(T)
    ).