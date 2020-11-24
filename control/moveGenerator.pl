:-include('boardController.pl').

display:-
    initial(Board),
    printBoard(Board).

test(Moves, Start, X):-
    initial(Board),
    getAllMoves(Start, X, Board, Moves, Moves, Moves).

getAllMoves(StartCoords, EndCoords, Board, NWDiagonalMoves, NEDiagonalMoves, ELineMoves):-
    generateAllMoves(StartCoords, EndCoords, [0|0], Board, NWDiagonalMoves, NEDiagonalMoves, ELineMoves).

generateAllMoves(StartCoords, [NWCoords, NECoords, ECoords, WCoords, SECoords, SWCoords], PreviousCoords, Board, NWDiagonalMoves, NEDiagonalMoves, ELineMoves):-
    
    % Get Path that starts on the northwest
    getNWMoves(StartCoords, StartCoords, NWCoords, PreviousCoords, Board, NWDiagonalMoves),

    % Get Path that starts on the northeast
    getNEMoves(StartCoords, StartCoords, NECoords, PreviousCoords, Board, NEDiagonalMoves),

    % Get Path that starts on the east
    getEMoves(StartCoords, StartCoords, ECoords, PreviousCoords, Board, ELineMoves),

    % Get Path that starts on the west 
    getWMoves(StartCoords, StartCoords, WCoords, PreviousCoords, Board, ELineMoves),

    % Get Path that starts on the southeast
    getSEMoves(StartCoords, StartCoords, SECoords, PreviousCoords, Board, NWDiagonalMoves),

    % Get Path that starts on the southwest
    getSWMoves(StartCoords, StartCoords, SWCoords, PreviousCoords, Board, NEDiagonalMoves).

/*


                        NORTH WEST MOVES


*/

/*
    getNWMoves(StartCoords, CurrentCoords, EndCoords, PreviousCoords, Board, NrMoves).
*/

getNWMoves(StartCoords, [CurrentColumn|CurrentRow], EndCoords, PreviousCoords, Board, NrMoves):-
    NewColumn is CurrentColumn - 1,
    NewRow is CurrentRow - 1,
    isValidPosition([NewColumn|NewRow], Board, StartCoords, PreviousCoords),
    NewNrMoves is NrMoves - 1,
    generateNWMoves(StartCoords, [NewColumn|NewRow], EndCoords, [CurrentColumn|CurrentRow], Board, NewNrMoves).

getNWMoves(_, _, [], _, _, _).

/*
    generateNWMoves(StartCoords, CurrentCoords, EndCoords, PreviousCoords, Board, NrMoves).
*/

generateNWMoves(StartCoords, [CurrentColumn|CurrentRow], [CurrentColumn|CurrentRow], PreviousCoords, Board, 0):-
        isValidPosition([CurrentColumn|CurrentRow], Board, StartCoords, PreviousCoords).

% Get the next move in the NorthWest direction
generateNWMoves(StartCoords, [CurrentColumn|CurrentRow], EndCoords, PreviousCoords, Board, NrMoves):-
    NewColumn is CurrentColumn - 1,
    NewRow is CurrentRow - 1,
    isValidPosition([NewColumn|NewRow], Board, StartCoords, PreviousCoords),
    NewNrMoves is NrMoves - 1,
    generateNWMoves(StartCoords, [NewColumn|NewRow], EndCoords, [CurrentColumn|CurrentRow], Board, NewNrMoves).

% Get the next move in the NorthEast direction
generateNWMoves(StartCoords, CurrentCoords, [NECoords, ECoords, WCoords, SECoords, SWCoords], PreviousCoords, Board, NrMoves):-
    write('GenerateNW\n'),
    write(CurrentCoords),
    write('\n'),
    % Get Path that starts on the northeast
    getNEMoves(StartCoords, CurrentCoords, NECoords, PreviousCoords, Board, NrMoves),

    % Get Path that starts on the east
    getEMoves(StartCoords, CurrentCoords, ECoords, PreviousCoords, Board, NrMoves),

    % Get Path that starts on the west 
    getWMoves(StartCoords, CurrentCoords, WCoords, PreviousCoords, Board, NrMoves),

    % Get Path that starts on the southeast
    getSEMoves(StartCoords, CurrentCoords, SECoords, PreviousCoords, Board, NrMoves),

    % Get Path that starts on the southwest
    getSWMoves(StartCoords, CurrentCoords, SWCoords, PreviousCoords, Board, NrMoves).

generateNWMoves(_, _, [], _, _, _).

/*


                        NORTH EAST MOVES


*/

/*
    getNEMoves(StartCoords, CurrentCoords, EndCoords, PreviousCoords, Board, NrMoves).
*/

getNEMoves(StartCoords, [CurrentColumn|CurrentRow], EndCoords, PreviousCoords, Board, NrMoves):-
    write('GetNE\n'),
    write([CurrentColumn|CurrentRow]),
    write('\n'),
    NewColumn is CurrentColumn + 1,
    NewRow is CurrentRow - 1,
    isValidPosition([NewColumn|NewRow], Board, StartCoords, PreviousCoords),
    NewNrMoves is NrMoves - 1,
    generateNEMoves(StartCoords, [NewColumn|NewRow], EndCoords, [CurrentColumn|CurrentRow], Board, NewNrMoves).

getNEMoves(_, _, [], _, _, _).

/*
    generateNEMoves(StartCoords, CurrentCoords, EndCoords, PreviousCoords, Board, NrMoves).
*/

generateNEMoves(StartCoords, [CurrentColumn|CurrentRow], [CurrentColumn|CurrentRow], PreviousCoords, Board, 0):-
        isValidPosition([CurrentColumn|CurrentRow], Board, StartCoords, PreviousCoords).

% Get the next move in the NorthEast direction
generateNEMoves(StartCoords, [CurrentColumn|CurrentRow], EndCoords, PreviousCoords, Board, NrMoves):-
    NewColumn is CurrentColumn + 1,
    NewRow is CurrentRow - 1,
    isValidPosition([NewColumn|NewRow], Board, StartCoords, PreviousCoords),
    NewNrMoves is NrMoves - 1,
    generateNEMoves(StartCoords, [NewColumn|NewRow], EndCoords, [CurrentColumn|CurrentRow], Board, NewNrMoves).

% Get the next move in the NorthEast direction
generateNEMoves(StartCoords, CurrentCoords, [NWCoords, ECoords, WCoords, SECoords, SWCoords], PreviousCoords, Board, NrMoves):-
    % Get Path that starts on the northeast
    getNWMoves(StartCoords, CurrentCoords, NWCoords, PreviousCoords, Board, NrMoves),

    % Get Path that starts on the east
    getEMoves(StartCoords, CurrentCoords, ECoords, PreviousCoords, Board, NrMoves),

    % Get Path that starts on the west 
    getWMoves(StartCoords, CurrentCoords, WCoords, PreviousCoords, Board, NrMoves),

    % Get Path that starts on the southeast
    getSEMoves(StartCoords, CurrentCoords, SECoords, PreviousCoords, Board, NrMoves),

    % Get Path that starts on the southwest
    getSWMoves(StartCoords, CurrentCoords, SWCoords, PreviousCoords, Board, NrMoves).

generateNEMoves(_, _, [], _, _, _).

/*


                        EAST MOVES


*/

/*
    getEMoves(StartCoords, CurrentCoords, EndCoords, PreviousCoords, Board, NrMoves).
*/

getEMoves(StartCoords, [CurrentColumn|CurrentRow], EndCoords, PreviousCoords, Board, NrMoves):-
    NewColumn is CurrentColumn + 2,
    isValidPosition([NewColumn|CurrentRow], Board, StartCoords, PreviousCoords),
    NewNrMoves is NrMoves - 1,
    generateEMoves(StartCoords, [NewColumn|CurrentRow], EndCoords, [CurrentColumn|CurrentRow], Board, NewNrMoves).

getEMoves(_, _, [], _, _, _).
/*
    generateEMoves(StartCoords, CurrentCoords, EndCoords, PreviousCoords, Board, NrMoves).
*/

generateEMoves(StartCoords, [CurrentColumn|CurrentRow], [CurrentColumn|CurrentRow], PreviousCoords, Board, 0):-
        isValidPosition([CurrentColumn|CurrentRow], Board, StartCoords, PreviousCoords).

% Get the next move in the East direction
generateEMoves(StartCoords, [CurrentColumn|CurrentRow], EndCoords, PreviousCoords, Board, NrMoves):-
    NewColumn is CurrentColumn + 2,
    isValidPosition([NewColumn|CurrentRow], Board, StartCoords, PreviousCoords),
    NewNrMoves is NrMoves - 1,
    generateEMoves(StartCoords, [NewColumn|CurrentRow], EndCoords, [CurrentColumn|CurrentRow], Board, NewNrMoves).

generateEMoves(StartCoords, CurrentCoords, [NWCoords, NECoords, WCoords, SECoords, SWCoords], PreviousCoords, Board, NrMoves):-
    % Get Path that starts on the northeast
    getNWMoves(StartCoords, CurrentCoords, NWCoords, PreviousCoords, Board, NrMoves),

    % Get Path that starts on the east
    getNEMoves(StartCoords, CurrentCoords, NECoords, PreviousCoords, Board, NrMoves),

    % Get Path that starts on the west 
    getWMoves(StartCoords, CurrentCoords, WCoords, PreviousCoords, Board, NrMoves),

    % Get Path that starts on the southeast
    getSEMoves(StartCoords, CurrentCoords, SECoords, PreviousCoords, Board, NrMoves),

    % Get Path that starts on the southwest
    getSWMoves(StartCoords, CurrentCoords, SWCoords, PreviousCoords, Board, NrMoves).

generateEMoves(_, _, [], _, _, _).


/*


                        WEST MOVES


*/

/*
    getWMoves(StartCoords, CurrentCoords, EndCoords, PreviousCoords, Board, NrMoves).
*/

getWMoves(StartCoords, [CurrentColumn|CurrentRow], EndCoords, PreviousCoords, Board, NrMoves):-
    NewColumn is CurrentColumn - 2,
    isValidPosition([NewColumn|CurrentRow], Board, StartCoords, PreviousCoords),
    NewNrMoves is NrMoves - 1,
    generateWMoves(StartCoords, [NewColumn|CurrentRow], EndCoords, [CurrentColumn|CurrentRow], Board, NewNrMoves).

getWMoves(_, _, [], _, _, _).

/*
    generateWMoves(StartCoords, CurrentCoords, EndCoords, PreviousCoords, Board, NrMoves).
*/

generateWMoves(StartCoords, [CurrentColumn|CurrentRow], [CurrentColumn|CurrentRow], PreviousCoords, Board, 0):-
        isValidPosition([CurrentColumn|CurrentRow], Board, StartCoords, PreviousCoords).

% Get the next move in the West direction
generateWMoves(StartCoords, [CurrentColumn|CurrentRow], EndCoords, PreviousCoords, Board, NrMoves):-
    NewColumn is CurrentColumn - 2,
    isValidPosition([NewColumn|CurrentRow], Board, StartCoords, PreviousCoords),
    NewNrMoves is NrMoves - 1,
    generateWMoves(StartCoords, [NewColumn|CurrentRow], EndCoords, [CurrentColumn|CurrentRow], Board, NewNrMoves).

generateWMoves(StartCoords, CurrentCoords, [NWCoords, NECoords, ECoords, SECoords, SWCoords], PreviousCoords, Board, NrMoves):-
    % Get Path that starts on the northeast
    getNWMoves(StartCoords, CurrentCoords, NWCoords, PreviousCoords, Board, NrMoves),

    % Get Path that starts on the east
    getNEMoves(StartCoords, CurrentCoords, NECoords, PreviousCoords, Board, NrMoves),

    % Get Path that starts on the west 
    getEMoves(StartCoords, CurrentCoords, ECoords, PreviousCoords, Board, NrMoves),

    % Get Path that starts on the southeast
    getSEMoves(StartCoords, CurrentCoords, SECoords, PreviousCoords, Board, NrMoves),

    % Get Path that starts on the southwest
    getSWMoves(StartCoords, CurrentCoords, SWCoords, PreviousCoords, Board, NrMoves).

generateWMoves(_, _, [], _, _, _).


/*


                        SOUTH EAST MOVES


*/

/*
    getSEMoves(StartCoords, CurrentCoords, EndCoords, PreviousCoords, Board, NrMoves).
*/

getSEMoves(StartCoords, [CurrentColumn|CurrentRow], EndCoords, PreviousCoords, Board, NrMoves):-
    NewColumn is CurrentColumn + 1,
    NewRow is CurrentRow + 1,
    isValidPosition([NewColumn|NewRow], Board, StartCoords, PreviousCoords),
    NewNrMoves is NrMoves - 1,
    generateSEMoves(StartCoords, [NewColumn|NewRow], EndCoords, [CurrentColumn|CurrentRow], Board, NewNrMoves).

getSEMoves(_, _, [], _, _, _).

/*
    generateSEMoves(StartCoords, CurrentCoords, EndCoords, PreviousCoords, Board, NrMoves).
*/

generateSEMoves(StartCoords, [CurrentColumn|CurrentRow], [CurrentColumn|CurrentRow], PreviousCoords, Board, 0):-
        isValidPosition([CurrentColumn|CurrentRow], Board, StartCoords, PreviousCoords).

% Get the next move in the SouthEast direction
generateSEMoves(StartCoords, [CurrentColumn|CurrentRow], EndCoords, PreviousCoords, Board, NrMoves):-
    NewColumn is CurrentColumn + 1,
    NewRow is CurrentRow + 1,
    isValidPosition([NewColumn|NewRow], Board, StartCoords, PreviousCoords),
    NewNrMoves is NrMoves - 1,
    generateSEMoves(StartCoords, [NewColumn|NewRow], EndCoords, [CurrentColumn|CurrentRow], Board, NewNrMoves).

% Get the next move in the West direction
generateSEMoves(StartCoords, CurrentCoords, [NWCoords, NECoords, ECoords, WCoords, SWCoords], PreviousCoords, Board, NrMoves):-
    % Get Path that starts on the northeast
    getNWMoves(StartCoords, CurrentCoords, NWCoords, PreviousCoords, Board, NrMoves),

    % Get Path that starts on the east
    getNEMoves(StartCoords, CurrentCoords, NECoords, PreviousCoords, Board, NrMoves),

    % Get Path that starts on the west 
    getEMoves(StartCoords, CurrentCoords, ECoords, PreviousCoords, Board, NrMoves),

    % Get Path that starts on the southeast
    getWMoves(StartCoords, CurrentCoords, WCoords, PreviousCoords, Board, NrMoves),

    % Get Path that starts on the southwest
    getSWMoves(StartCoords, CurrentCoords, SWCoords, PreviousCoords, Board, NrMoves).

generateSEMoves(_, _, [], _, _, _).

/*


                        SOUTH WEST MOVES


*/

/*
    getSWMoves(StartCoords, CurrentCoords, EndCoords, PreviousCoords, Board, NrMoves).
*/

getSWMoves(StartCoords, [CurrentColumn|CurrentRow], EndCoords, PreviousCoords, Board, NrMoves):-
    NewColumn is CurrentColumn - 1,
    NewRow is CurrentRow + 1,
    isValidPosition([NewColumn|NewRow], Board, StartCoords, PreviousCoords),
    NewNrMoves is NrMoves - 1,
    generateSWMoves(StartCoords, [NewColumn|NewRow], EndCoords, [CurrentColumn|CurrentRow], Board, NewNrMoves).

getSWMoves(_, _, [], _, _, _).

/*
    generateSWMoves(StartCoords, CurrentCoords, EndCoords, PreviousCoords, Board, NrMoves).
*/

generateSWMoves(StartCoords, [CurrentColumn|CurrentRow], [CurrentColumn|CurrentRow], PreviousCoords, Board, 0):-
        isValidPosition([CurrentColumn|CurrentRow], Board, StartCoords, PreviousCoords).


% Get the next move in the SouthWest direction
generateSWMoves(StartCoords, [CurrentColumn|CurrentRow], EndCoords, PreviousCoords, Board, NrMoves):-
    NewColumn is CurrentColumn - 1,
    NewRow is CurrentRow + 1,
    isValidPosition([NewColumn|NewRow], Board, StartCoords, PreviousCoords),
    NewNrMoves is NrMoves - 1,
    generateSWMoves(StartCoords, [NewColumn|NewRow], EndCoords, [CurrentColumn|CurrentRow], Board, NewNrMoves).


generateSWMoves(StartCoords, CurrentCoords, [NWCoords, NECoords, ECoords, WCoords, SECoords], PreviousCoords, Board, NrMoves):-
    % Get Path that starts on the northeast
    getNWMoves(StartCoords, CurrentCoords, NWCoords, PreviousCoords, Board, NrMoves),

    % Get Path that starts on the east
    getNEMoves(StartCoords, CurrentCoords, NECoords, PreviousCoords, Board, NrMoves),

    % Get Path that starts on the west 
    getEMoves(StartCoords, CurrentCoords, ECoords, PreviousCoords, Board, NrMoves),

    % Get Path that starts on the southeast
    getWMoves(StartCoords, CurrentCoords, WCoords, PreviousCoords, Board, NrMoves),

    % Get Path that starts on the southwest
    getSEMoves(StartCoords, CurrentCoords, SECoords, PreviousCoords, Board, NrMoves).

generateSWMoves(_, _, [], _, _, _).

/*
    Check if it is a valid position
*/
isValidPosition([CurrentColumn|CurrentRow], Board, StartCoords, PreviousCoords):-
    % Position must be diferent then start position
    listIsDifferent([CurrentColumn|CurrentRow], StartCoords),

    % Position must be diferent then previous position
    listIsDifferent([CurrentColumn|CurrentRow], PreviousCoords),

    % Position must be empty
    checkValidPosition([CurrentColumn|CurrentRow], Board, 'empty').