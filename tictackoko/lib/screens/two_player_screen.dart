import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/game_button.dart';

class TwoPlayerScreen extends StatefulWidget {
  const TwoPlayerScreen({super.key});

  @override
  State<TwoPlayerScreen> createState() => _TwoPlayerScreenState();
}

class _TwoPlayerScreenState extends State<TwoPlayerScreen> {
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

  Widget _buildPlayerScore(String player, int score, Color color, bool isActive) {
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
