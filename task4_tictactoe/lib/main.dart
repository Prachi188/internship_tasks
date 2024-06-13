import 'package:flutter/material.dart';

void main() {
  runApp(TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TicTacToeScreen(),
    );
  }
}

class TicTacToeScreen extends StatefulWidget {
  @override
  _TicTacToeScreenState createState() => _TicTacToeScreenState();
}

class _TicTacToeScreenState extends State<TicTacToeScreen> {
  List<List<String?>> _board =
      List.generate(3, (_) => List.generate(3, (_) => null));
  String _currentPlayer = 'X';
  bool _gameOver = false;
  String _winner = '';

  void _resetGame() {
    setState(() {
      _board = List.generate(3, (_) => List.generate(3, (_) => null));
      _currentPlayer = 'X';
      _gameOver = false;
      _winner = '';
    });
  }

  void _handleTap(int row, int col) {
    if (_board[row][col] != null || _gameOver) return;

    setState(() {
      _board[row][col] = _currentPlayer;
      if (_checkWinner(row, col)) {
        _gameOver = true;
        _winner = _currentPlayer;
      } else if (_board.every((row) => row.every((cell) => cell != null))) {
        _gameOver = true;
        _winner = 'Draw';
      } else {
        _currentPlayer = _currentPlayer == 'X' ? 'O' : 'X';
      }
    });
  }

  bool _checkWinner(int row, int col) {
    // Check row
    if (_board[row].every((cell) => cell == _currentPlayer)) return true;
    // Check column
    if (_board.every((row) => row[col] == _currentPlayer)) return true;
    // Check diagonal
    if (row == col &&
        _board.every((row) => row[_board.indexOf(row)] == _currentPlayer))
      return true;
    // Check anti-diagonal
    if (row + col == 2 &&
        _board.every((row) => row[2 - _board.indexOf(row)] == _currentPlayer))
      return true;

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tic Tac Toe'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            _gameOver
                ? (_winner == 'Draw'
                    ? 'It\'s a Draw!'
                    : 'Player $_winner Wins!')
                : 'Player $_currentPlayer\'s Turn',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20.0),
          _buildBoard(),
          SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: _resetGame,
            child: Text('Reset'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
              textStyle: TextStyle(fontSize: 20.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBoard() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(16.0),
        width: 300.0,
        height: 300.0,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: GridView.builder(
          itemCount: 9,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          itemBuilder: (context, index) {
            int row = index ~/ 3;
            int col = index % 3;
            return GestureDetector(
              onTap: () => _handleTap(row, col),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black),
                ),
                child: Center(
                  child: Text(
                    _board[row][col] ?? '',
                    style: TextStyle(
                        fontSize: 48.0,
                        fontWeight: FontWeight.bold,
                        color:
                            _board[row][col] == 'X' ? Colors.blue : Colors.red),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
