import 'package:flutter/material.dart';
import 'results_page.dart'; // Import the ResultsPage

class TicTacToeScreen extends StatefulWidget {
  const TicTacToeScreen({super.key});

  @override
  _TicTacToeScreenState createState() => _TicTacToeScreenState();
}

class _TicTacToeScreenState extends State<TicTacToeScreen>
    with SingleTickerProviderStateMixin {
  List<String> _board = List.filled(9, '', growable: false);
  String _currentPlayer = 'X';
  bool _gameOver = false;
  String _gameResult = '';
  double _opacity = 0.0; // Opacity for the win message
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // Initialize animation controller
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );
  }

  void _resetGame() {
    setState(() {
      _board = List.filled(9, '', growable: false);
      _currentPlayer = 'X';
      _gameOver = false;
      _gameResult = '';
      _opacity = 0.0; // Reset opacity
    });
  }

  void _checkWinner() {
    List<List<int>> winningCombinations = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6]
    ];

    for (List<int> combination in winningCombinations) {
      String a = _board[combination[0]];
      String b = _board[combination[1]];
      String c = _board[combination[2]];

      if (a.isNotEmpty && a == b && b == c) {
        setState(() {
          _gameOver = true;
          _gameResult = 'Player $a Wins!';
          _opacity = 1.0; // Show the win message
        });

        // Trigger the winning animation
        _controller.forward().then((_) {
          _controller.reverse();
          Future.delayed(const Duration(milliseconds: 300), () {
            setState(() {
              _opacity = 0.0; // Fade out the message
            });
          });
        });

        // Navigate to the results page after 2 seconds
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResultsPage(result: _gameResult, resetGame: _resetGame),
            ),
          );
        });

        return;
      }
    }

    // Check if it's a draw
    if (!_board.contains('')) {
      setState(() {
        _gameOver = true;
        _gameResult = "It's a Draw!";
        _opacity = 1.0;

        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            _opacity = 0.0;
          });
        });

        // Navigate to the results page after 2 seconds
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResultsPage(result: _gameResult, resetGame: _resetGame),
            ),
          );
        });
      });
    }
  }

  void _handleTap(int index) {
    if (_board[index].isEmpty && !_gameOver) {
      setState(() {
        _board[index] = _currentPlayer;
        _checkWinner();
        if (!_gameOver) {
          _currentPlayer = _currentPlayer == 'X' ? 'O' : 'X';
        }
      });
    }
  }

  Widget _buildCell(int index) {
    return GestureDetector(
      onTap: () {
        _handleTap(index);
        _controller.forward().then((_) => _controller.reverse()); // Scale animation on tap
      },
      child: Container(
        height: 80, // Height of each cell
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          color: Colors.white, // Cell color
          borderRadius: BorderRadius.circular(8), // Rounded corners
        ),
        child: Center(
          child: Text(
            _board[index],
            style: TextStyle(
              fontSize: 48, // Use a larger font size for the symbols
              fontWeight: FontWeight.bold,
              fontFamily: 'Lobster', // Use the custom font
              color: _board[index] == 'X' ? Colors.red : Colors.blue, // Different colors for X and O
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic Tac Toe - Multiplayer'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent, // Stylish background for the app bar
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlueAccent, Colors.blue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Container(
            width: 300, // Set a fixed width for the game area
            height: 400, // Set a fixed height for the game area
            padding: const EdgeInsets.all(16.0), // Add padding around the grid
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8), // Semi-transparent background for the grid
              borderRadius: BorderRadius.circular(12.0), // Rounded corners
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0, 4),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1.0, // Make cells square
                    ),
                    itemCount: 9,
                    itemBuilder: (context, index) {
                      return _buildCell(index);
                    },
                  ),
                ),
                // Animated win message
                AnimatedOpacity(
                  opacity: _opacity,
                  duration: const Duration(seconds: 1),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Transform.scale(
                       scale: _gameResult.isNotEmpty ? 1.2 : 1.0,
                      child: Text(
                        _gameResult,
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _resetGame,
                  child: const Text('Restart Game'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}