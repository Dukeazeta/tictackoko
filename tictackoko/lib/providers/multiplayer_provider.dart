import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/network_service.dart';

enum GameConnectionState {
  disconnected,
  hosting,
  joining,
  connected,
}

class MultiplayerState {
  final GameConnectionState connectionState;
  final String? errorMessage;
  final bool isMyTurn;
  final List<String> board;
  final String? winner;

  MultiplayerState({
    this.connectionState = GameConnectionState.disconnected,
    this.errorMessage,
    this.isMyTurn = false,
    this.board = const ['', '', '', '', '', '', '', '', ''],
    this.winner,
  });

  MultiplayerState copyWith({
    GameConnectionState? connectionState,
    String? errorMessage,
    bool? isMyTurn,
    List<String>? board,
    String? winner,
  }) {
    return MultiplayerState(
      connectionState: connectionState ?? this.connectionState,
      errorMessage: errorMessage,
      isMyTurn: isMyTurn ?? this.isMyTurn,
      board: board ?? this.board,
      winner: winner ?? this.winner,
    );
  }
}

class MultiplayerNotifier extends StateNotifier<MultiplayerState> {
  final NetworkService _networkService = NetworkService();
  
  MultiplayerNotifier() : super(MultiplayerState()) {
    _networkService.messageStream.listen(_handleMessage);
  }

  Future<void> hostGame() async {
    try {
      state = state.copyWith(
        connectionState: GameConnectionState.hosting,
        errorMessage: null,
      );
      await _networkService.startServer();
      state = state.copyWith(
        connectionState: GameConnectionState.connected,
        isMyTurn: true,
      );
    } catch (e) {
      state = state.copyWith(
        connectionState: GameConnectionState.disconnected,
        errorMessage: 'Failed to host game: $e',
      );
    }
  }

  Future<void> joinGame(String host) async {
    try {
      state = state.copyWith(
        connectionState: GameConnectionState.joining,
        errorMessage: null,
      );
      await _networkService.connectToServer(host);
      state = state.copyWith(
        connectionState: GameConnectionState.connected,
        isMyTurn: false,
      );
    } catch (e) {
      state = state.copyWith(
        connectionState: GameConnectionState.disconnected,
        errorMessage: 'Failed to join game: $e',
      );
    }
  }

  void makeMove(int index) {
    if (!state.isMyTurn || state.board[index].isNotEmpty || state.winner != null) {
      return;
    }

    final newBoard = List<String>.from(state.board);
    newBoard[index] = state.isMyTurn ? 'X' : 'O';
    
    _networkService.sendMessage(index.toString());
    
    state = state.copyWith(
      board: newBoard,
      isMyTurn: false,
    );
    
    _checkWinner(newBoard);
  }

  void _handleMessage(String message) {
    final index = int.tryParse(message);
    if (index != null && index >= 0 && index < 9) {
      final newBoard = List<String>.from(state.board);
      newBoard[index] = !state.isMyTurn ? 'X' : 'O';
      
      state = state.copyWith(
        board: newBoard,
        isMyTurn: true,
      );
      
      _checkWinner(newBoard);
    }
  }

  void _checkWinner(List<String> board) {
    // Winning combinations
    final lines = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columns
      [0, 4, 8], [2, 4, 6], // Diagonals
    ];

    for (final line in lines) {
      if (board[line[0]].isNotEmpty &&
          board[line[0]] == board[line[1]] &&
          board[line[0]] == board[line[2]]) {
        state = state.copyWith(winner: board[line[0]]);
        return;
      }
    }

    if (!board.contains('')) {
      state = state.copyWith(winner: 'Draw');
    }
  }

  @override
  void dispose() {
    _networkService.dispose();
    super.dispose();
  }
}

final multiplayerProvider =
    StateNotifierProvider<MultiplayerNotifier, MultiplayerState>(
        (ref) => MultiplayerNotifier());
