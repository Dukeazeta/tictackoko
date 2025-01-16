import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/settings_provider.dart';
import '../utils/constants.dart';
import '../widgets/game_button.dart';

class GameScreen extends ConsumerStatefulWidget {
  final bool isVsAI;
  const GameScreen({super.key, required this.isVsAI});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  List<String> board = List.filled(9, '');
  bool isXTurn = true;
  String? winner;
  int xScore = 0;
  int oScore = 0;

  void _makeMove(int index) {
    if (board[index].isEmpty && winner == null) {
      setState(() {
        board[index] = isXTurn ? 'X' : 'O';
        winner = _checkWinnerForBoard(board);
        if (winner != null && winner != 'Draw') {
          if (winner == 'X') {
            xScore++;
          } else if (winner == 'O') {
            oScore++;
          }
        }
        isXTurn = !isXTurn;
      });

      if (winner == null && !isXTurn) {
        _makeAIMove();
      }
    }
  }

  void _makeAIMove() {
    final settingsAsync = ref.read(settingsNotifierProvider);
    
    settingsAsync.whenData((settings) {
      int bestMove;
      switch (settings.aiDifficulty) {
        case AIDifficulty.easy:
          bestMove = _getRandomMove();
          break;
        case AIDifficulty.medium:
          bestMove = _getMediumMove();
          break;
        case AIDifficulty.hard:
          bestMove = _getBestMove();
          break;
      }
      Future.delayed(
          const Duration(milliseconds: 500), () => _makeMove(bestMove));
    });
  }

  int _getRandomMove() {
    final emptySpots =
        List.generate(9, (i) => i).where((i) => board[i].isEmpty).toList();
    return emptySpots[
        DateTime.now().millisecondsSinceEpoch % emptySpots.length];
  }

  int _getMediumMove() {
    // 50% chance of making the best move, 50% chance of making a random move
    return DateTime.now().millisecondsSinceEpoch % 2 == 0
        ? _getBestMove()
        : _getRandomMove();
  }

  int _getBestMove() {
    int bestScore = -1000;
    int bestMove = 0;

    for (int i = 0; i < 9; i++) {
      if (board[i].isEmpty) {
        board[i] = 'O';
        int score = _minimax(board, 0, false);
        board[i] = '';

        if (score > bestScore) {
          bestScore = score;
          bestMove = i;
        }
      }
    }

    return bestMove;
  }

  int _minimax(List<String> board, int depth, bool isMaximizing) {
    String? result = _checkWinnerForBoard(board);
    if (result != null) {
      return result == 'O'
          ? 10 - depth
          : result == 'X'
              ? depth - 10
              : 0;
    }

    if (isMaximizing) {
      int bestScore = -1000;
      for (int i = 0; i < 9; i++) {
        if (board[i].isEmpty) {
          board[i] = 'O';
          bestScore = max(bestScore, _minimax(board, depth + 1, false));
          board[i] = '';
        }
      }
      return bestScore;
    } else {
      int bestScore = 1000;
      for (int i = 0; i < 9; i++) {
        if (board[i].isEmpty) {
          board[i] = 'X';
          bestScore = min(bestScore, _minimax(board, depth + 1, true));
          board[i] = '';
        }
      }
      return bestScore;
    }
  }

  String? _checkWinnerForBoard(List<String> board) {
    for (String player in ['X', 'O']) {
      // Rows
      for (int i = 0; i < 9; i += 3) {
        if (board[i] == player &&
            board[i + 1] == player &&
            board[i + 2] == player) {
          return player;
        }
      }
      // Columns
      for (int i = 0; i < 3; i++) {
        if (board[i] == player &&
            board[i + 3] == player &&
            board[i + 6] == player) {
          return player;
        }
      }
      // Diagonals
      if (board[0] == player && board[4] == player && board[8] == player) {
        return player;
      }
      if (board[2] == player && board[4] == player && board[6] == player) {
        return player;
      }
    }
    // Check for draw
    if (!board.contains('')) return 'Draw';
    return null;
  }

  void _resetGame() {
    setState(() {
      board = List.filled(9, '');
      isXTurn = true;
      winner = null;
    });
  }

  Widget _buildPlayerScore(
      String player, int score, Color color, bool isActive) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isActive ? color : Colors.black,
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            offset: const Offset(4, 4),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            player,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              fontFamily: 'ClashGrotesk',
              color: isActive ? color : Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$score',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              fontFamily: 'ClashGrotesk',
              color: isActive ? color : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GameButton(
                    text: '',
                    width: 50,
                    height: 50,
                    child: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                  GameButton(
                    text: '',
                    width: 50,
                    height: 50,
                    child: const Icon(Icons.refresh, color: Colors.black),
                    onPressed: _resetGame,
                  ),
                ],
              ),
            ),
            const Spacer(flex: 2),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildPlayerScore('X', xScore, Colors.blue, isXTurn),
                  _buildPlayerScore('O', oScore, Colors.red, !isXTurn),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.black,
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    offset: const Offset(4, 4),
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Text(
                winner == null
                    ? '${isXTurn ? "X" : "O"}\'s Turn'
                    : winner == 'Draw'
                        ? 'Draw!'
                        : '$winner Wins!',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'ClashGrotesk',
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.85,
              child: AspectRatio(
                aspectRatio: 1,
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: 9,
                  itemBuilder: (context, index) {
                    return GameButton(
                      text: board[index],
                      onPressed: () => _makeMove(index),
                      textStyle: const TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'ClashGrotesk',
                        color: Colors.black,
                      ),
                    );
                  },
                ),
              ),
            ),
            const Spacer(flex: 3),
          ],
        ),
      ),
    );
  }
}

int max(int a, int b) => a > b ? a : b;
int min(int a, int b) => a < b ? a : b;
