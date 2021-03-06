:-include('moveGenerator.pl').



/**
    This file is where we make all the function that move the pieces.
*/

/*
    takeTurn(GameState, NewGameState)
    Player move has 3 stages.
    First the player moves one of its pieces.
    Then it moves one of the enemy pieces.
    And it places one piece. 
*/

takeTurn([Board, [PlayerColor, PlayerPieces, PlayerSemaphores, LastPlay], EnemyPlayer], [NewBoard, UpdatedPlayer, NewEnemyPlayer]):-
    % Stage 1: Move Player Piece
    displayMovePieceHead,
    display_game(Board),
    movePlayerDisc(Board, [PlayerColor, PlayerPieces, PlayerSemaphores, LastPlay], EnemyPlayer, BoardMoved, PlayerAfterMove, EnemyAfterMove),

    % Stage 2: Move Enemy Piece
    displayMoveEnemyPieceHead,
    display_game(BoardMoved),
    moveEnemyDisc(BoardMoved, EnemyAfterMove, PlayerAfterMove, BoardEnemyMoved, NewEnemyPlayer, PlayerEnemyMove),

    % Stage 3: Place a New Piece
    displayPlacePieceHead,
    display_game(BoardEnemyMoved),
    placeDisc(BoardEnemyMoved, PlayerEnemyMove, NewBoard, UpdatedPlayer).

/*
    placeDisc(Board, Player, NewBoard)
    Asks where to place the piece.
    Checks if the place is valid.
    And places a piece of the Player in the Board at the coords given.
*/
placeDisc(Board, [PieceColor, NrPieces, PlayerSemaphores, LastMove], NextTurnBoard, [PieceColor, NewNrPieces, PlayerSemaphores, Coords]):-
    NrPieces > 0,
    pieceColorLower(PieceColor, LowerColor),
    getValidPosition(Coords, Board, 'empty', LowerColor),
    setPieceAt(Coords, Board, PieceColor, NewBoard),
    NewNrPieces is NrPieces - 1,
    lastMoveToLowerCase(LastMove, NewBoard, NextTurnBoard, PieceColor).

placeDisc(Board, [PieceColor, NrPieces, PlayerSemaphores, LastMove], NextTurnBoard, [PieceColor, NrPieces, PlayerSemaphores, []]):-
    write('You cant place any more pieces\n'),
    lastMoveToLowerCase(LastMove, Board, NextTurnBoard, PieceColor),
    sleep(1).


/*
    setup(Board, Player, NewBoard)
    Asks where to place the yellowpiece.
    Checks if the place is valid.
    And places a piece in the Board at the coords given. Does this until five pieces have been putted.
*/
setupPvP(5,Board,_,Board).

setupPvP(Counter,Board, PieceColor, NewTurnBoard):-
	% Display Information
    displayPlayerTurn(PieceColor),
    displayPlaceYellowPieces,
	display_game(Board),

    % Ask for Valid position and put a piece there
    getValidYellowPosition(Coords, Board, 'empty'),
    setPieceAt(Coords, Board, 'yellow', NewBoard),
	
    % Ask the other player to put another yellow piece
    PiecesPlaced is Counter+1,
	enemyColor(PieceColor,EnemyPieceColor),
	setupPvP(PiecesPlaced,NewBoard,EnemyPieceColor,NewTurnBoard).

/*
    setup(Board, Player, NewBoard)
    Asks where to place the yellowpiece.
    Checks if the place is valid.
    And places a piece in the Board at the coords given. Does this until five pieces have been putted.
*/
setup(5,Board,_,Board).

setup(Counter,Board, PieceColor, NewTurnBoard):-
	% Display Information
    displayPlayerTurn(PieceColor),
    displayPlaceYellowPieces,
	display_game(Board),

    % Ask for Valid position and put a piece there
    getValidYellowPosition(Coords, Board, 'empty'),
    setPieceAt(Coords, Board, 'yellow', NewBoard),
	
    % Ask the other player to put another yellow piece
    Counter1 is Counter+1,
	enemyColor(PieceColor,EnemyPieceColor),
	setup(Counter1,NewBoard,EnemyPieceColor,NewTurnBoard).

setup(_, Player, _, Player).
/*
    movePlayerDisc(Board, Player, EnemyPlayer, BoardMoved, UpdatedPlayer, UpdatedEnemy)
    Asks the player for a piece to move and where to place it.
    Moves that piece to the desired place, leaving the spot empty.
*/
movePlayerDisc(Board, [PieceColor, PlayerPieces, PlayerSemaphores, PlayerLastMove], [EnemyColor, EnemyPieces, EnemySemaphores, EnemyLastMove], BoardMoved, UpdatedPlayer, UpdatedEnemy):-
    % There must be pieces on the board that as not been put there in the last play
    PlayerPieces < 20,
    pieceColorLower(PieceColor, LowerColer),
    existsInListofLists(Board, LowerColer),

    % Ask for a piece to move
    getValidPiece(Coords, Board, LowerColer),
    
    % Generate all possible Moves
    getNumberMoves(Board, Coords, [MovesNW, MovesNE, MovesE]),
    valid_moves(Coords, EndCoords, Board, MovesNW, MovesNE, MovesE),

    % Ask for a play and do it
    selectMove(EndCoords, SelectedMove),
    nth0(SelectedMove, EndCoords, MoveSelected, _),
    move(Board, [Coords, MoveSelected],  BoardPieceMoved),

    % Check for Sempahores
    getSemaphores(MoveSelected, LowerColer, BoardPieceMoved, NrSemaphores, BoardMoved),
    updatePlayers([PieceColor, PlayerPieces, PlayerSemaphores, PlayerLastMove], [EnemyColor, EnemyPieces, EnemySemaphores, EnemyLastMove], NrSemaphores, UpdatedPlayer, UpdatedEnemy, 'player').


movePlayerDisc(Board, [PieceColor, PlayerPieces, PlayerSemaphores, PlayerLastMove], EnemyPlayer, Board, [PieceColor, PlayerPieces, PlayerSemaphores, PlayerLastMove], EnemyPlayer):-
    write('There are no '),
    write(PieceColor),
    write(' pieces with valid moves.\n'),
    sleep(1).

/*
    moveEnemyDisc(Board, Player, EnemyPlayer, BoardMoved, UpdatedPlayer, UpdatedEnemy)
    Asks the player for a piece to move and where to place it.
    Moves that piece to the desired place, leaving the spot empty.
*/
moveEnemyDisc(Board, [EnemyPieceColor, EnemyPieces, EnemySemaphores, EnemyLastMove], Player, BoardMoved, UpdatedEnemy, UpdatedPlayer):-
    % There must be pieces on the board that as not been put there in the last play
    EnemyPieces < 20,
    pieceColorLower(EnemyPieceColor, LowerColer),
    existsInListofLists(Board, LowerColer),

    % Ask for a piece to move
    getValidPiece(Coords, Board, LowerColer),
    
    % Generate all possible Moves
    getNumberMoves(Board, Coords, [MovesNW, MovesNE, MovesE]),
    valid_moves(Coords, EndCoords, Board, MovesNW, MovesNE, MovesE),

    % Ask for a play and do it
    selectMove(EndCoords, SelectedMove),
    nth0(SelectedMove, EndCoords, MoveSelected, _),
    move(Board, [Coords, MoveSelected],  BoardPieceMoved),

    % Check for Sempahores
    getSemaphores(MoveSelected, LowerColer, BoardPieceMoved, NrSemaphores, BoardMoved),
    updatePlayers(Player, [EnemyPieceColor, EnemyPieces, EnemySemaphores, EnemyLastMove], NrSemaphores, UpdatedPlayer, UpdatedEnemy, 'enemy').

moveEnemyDisc(Board, [EnemyPieceColor, EnemyPieces, EnemySemaphores, EnemyLastMove], Player, Board, [EnemyPieceColor, EnemyPieces, EnemySemaphores, EnemyLastMove], Player):-
    write('There are no '),
    write(EnemyPieceColor),
    write(' pieces with valid moves.\n'),
    sleep(1).

/*
    move(GameState, Move, NewGameState).
    Applies the move into GameState
    The change is saved in NewGameState.
*/
move(GameState, [Coords, MoveSelected], NewGameState):-
    getPieceAt(Coords, GameState, Piece),
    setPieceAt(Coords, GameState, 'empty', IntermidiateGameState),
    setPieceAt(MoveSelected, IntermidiateGameState, Piece, NewGameState).

/*
    updatePlayers(Player, EnemyPlayer, NrSemaphores, UpdatedPlayer, UpdatedEnemy, MovedPiece).
    Updates the player acoording to the type of piece moved (saved in MovedPiece).
    If there are any semaphores it adds tthe number os semaphores to the current player.
    It also returns the pieces that have been removed from the board to each player.
*/ 

updatePlayers(Player, Enemy, 0, Player, Enemy, _).

% If there is only one Semaphore it doenst matter the moved piece since only one piece of each player has beed returned to them
updatePlayers([PlayerColor, PlayerPieces, PlayerSemaphores, PlayerLastMove], [EnemyPieceColor, EnemyPieces, EnemySemaphores, EnemyLastMove], 1, [PlayerColor, UpdatedPlayerPieces, UpdatedPlayerSemaphores, PlayerLastMove], [EnemyPieceColor, UpdatedEnemyPieces, EnemySemaphores, EnemyLastMove], _):-
    UpdatedPlayerSemaphores is PlayerSemaphores + 1,
    UpdatedPlayerPieces is PlayerPieces + 1,
    UpdatedEnemyPieces is EnemyPieces + 1.

% If there are more than 1 semaphore and the piece moved was of the player
% then the enemy player will receive 2 pieces and the player will only receive one. The sempahore is of type (EnemyColor - Yellow - PlayerColour - Yellow - EnemyColor)
updatePlayers([PlayerColor, PlayerPieces, PlayerSemaphores, PlayerLastMove], [EnemyPieceColor, EnemyPieces, EnemySemaphores, EnemyLastMove], NrSemaphores, [PlayerColor, UpdatedPlayerPieces, UpdatedPlayerSemaphores, PlayerLastMove], [EnemyPieceColor, UpdatedEnemyPieces, EnemySemaphores, EnemyLastMove], 'player'):-
    UpdatedPlayerSemaphores is PlayerSemaphores + NrSemaphores,
    PiecesUsed is NrSemaphores - 1,
    UpdatedPlayerPieces is PlayerPieces + PiecesUsed,
    UpdatedEnemyPieces is EnemyPieces + NrSemaphores.

% If there are more  than 2 semaphores adn the piece moved was of the enemy player then its the reverse from the previous predicate.
updatePlayers([PlayerColor, PlayerPieces, PlayerSemaphores, PlayerLastMove], [EnemyPieceColor, EnemyPieces, EnemySemaphores, EnemyLastMove], NrSemaphores, [PlayerColor, UpdatedPlayerPieces, UpdatedPlayerSemaphores, PlayerLastMove], [EnemyPieceColor, UpdatedEnemyPieces, EnemySemaphores, EnemyLastMove], 'enemy'):-
    UpdatedPlayerSemaphores is PlayerSemaphores + NrSemaphores,
    PiecesUsed is NrSemaphores - 1,
    UpdatedPlayerPieces is PlayerPieces + NrSemaphores,
    UpdatedEnemyPieces is EnemyPieces + PiecesUsed.

