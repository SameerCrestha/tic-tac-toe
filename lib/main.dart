import 'package:flutter/material.dart';
import 'package:tic_tac_toe/animated_text.dart';
import 'package:tic_tac_toe/box_container.dart';
import 'package:tic_tac_toe/enums.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Turn turn = Turn.player1;
  List<List<BoxState>> boxState = [
    [BoxState.empty, BoxState.empty, BoxState.empty],
    [BoxState.empty, BoxState.empty, BoxState.empty],
    [BoxState.empty, BoxState.empty, BoxState.empty],
  ];
  int player1Score = 0;
  int player2Score = 0;
  bool checkGameDraw() {
    bool flag = true;
    for (var row in boxState) {
      for (var element in row) {
        if (element == BoxState.empty) {
          flag = false;
          return flag;
        }
      }
    }
    return flag;
  }

  void resetGame() {
    setState(() {
      if (turn == Turn.player2) {
        turn = Turn.player1;
      } else {
        turn = Turn.player2;
      }
      boxState = [
        [BoxState.empty, BoxState.empty, BoxState.empty],
        [BoxState.empty, BoxState.empty, BoxState.empty],
        [BoxState.empty, BoxState.empty, BoxState.empty],
      ];
    });
  }

  void updatePoint(Turn turn) {
    if (turn == Turn.player1) {
      setState(() {
        player1Score++;
      });
    } else {
      setState(() {
        player2Score++;
      });
    }
  }

  Future<void> checkWinner() async {
    bool isWinCondition = checkWinCondition(boxState);
    bool isGameDraw = checkGameDraw();
    if (isWinCondition | isGameDraw) {
      await showModalBottomSheet(
        backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
        context: context,
        builder: (context) {
          return Container(
            decoration: const BoxDecoration(color: Colors.black87),
            height: 400,
            width: double.infinity,
            child: Center(
                child: isWinCondition
                    ? Text(
                        '${turn.name.toUpperCase()} won!',
                        style: const TextStyle(color: Colors.white),
                      )
                    : const Text(
                        'Draw!',
                        style: const TextStyle(color: Colors.white),
                      )),
          );
        },
      ).whenComplete(
        () {
          if (isWinCondition) {
            updatePoint(turn);
          }
          resetGame();
        },
      );
    }
  }

  Future<void> onClickHandler(int rowIndex, int columnIndex) async {
    if (boxState[rowIndex][columnIndex] == BoxState.empty) {
      if (turn == Turn.player1) {
        setState(() {
          boxState[rowIndex][columnIndex] = BoxState.circle;
        });

        await checkWinner();
        setState(() {
          turn = Turn.player2;
        });
      } else {
        setState(() {
          boxState[rowIndex][columnIndex] = BoxState.cross;
        });
        await checkWinner();
        setState(() {
          turn = Turn.player1;
        });
      }
    }
  }

  bool checkWinCondition(List<List<BoxState>> boxState) {
    // Check rows
    for (int i = 0; i < boxState.length; i++) {
      BoxState currentSymbol = boxState[i][0];
      if (currentSymbol != BoxState.empty &&
          currentSymbol == boxState[i][1] &&
          currentSymbol == boxState[i][2]) {
        return true;
      }
    }

    // Check columns
    for (int i = 0; i < boxState.length; i++) {
      BoxState currentSymbol = boxState[0][i];
      if (currentSymbol != BoxState.empty &&
          currentSymbol == boxState[1][i] &&
          currentSymbol == boxState[2][i]) {
        return true;
      }
    }

    // Check diagonals
    BoxState leftDiagonal = boxState[0][0];
    BoxState rightDiagonal = boxState[0][2];

    if (leftDiagonal != BoxState.empty &&
        leftDiagonal == boxState[1][1] &&
        leftDiagonal == boxState[2][2]) {
      return true;
    }

    if (rightDiagonal != BoxState.empty &&
        rightDiagonal == boxState[1][1] &&
        rightDiagonal == boxState[2][0]) {
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: DefaultTextStyle(
          style: const TextStyle(fontSize: 18, color: Colors.white),
          child: Container(
            decoration:
                const BoxDecoration(color: Color.fromARGB(255, 96, 86, 86)),
            padding: const EdgeInsets.all(16),
            height: double.infinity,
            width: double.infinity,
            child: LayoutBuilder(
              builder: (context, constraints) {
                Axis direction = Axis.vertical;
                if (constraints.maxWidth > 600) {
                  direction = Axis.horizontal;
                }
                return Flex(
                  direction: direction,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            const Text("Player 1"),
                            const Icon(
                              Icons.circle_outlined,
                              size: 40,
                            ),
                            Row(
                              children: [
                                const Text("Score:"),
                                AnimatedText(text: player1Score.toString())
                              ],
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 40,
                          width: 40,
                        ),
                        Column(
                          children: [
                            const Text("Player 2"),
                            const Icon(
                              Icons.close,
                              size: 40,
                            ),
                            Row(
                              children: [
                                const Text("Score:"),
                                AnimatedText(text: player2Score.toString())
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    AnimatedText(text: "${turn.name.toUpperCase()} turn"),
                    const Spacer(),
                    Center(
                      child: Column(
                        children: boxState.asMap().entries.map((entry) {
                          int rowIndex = entry.key;
                          List<BoxState> row = entry.value;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: row.asMap().entries.map((entry) {
                              int columnIndex = entry.key;
                              BoxState state = entry.value;
                              return BoxContainer(
                                state: state,
                                onClickHandler: () =>
                                    onClickHandler(rowIndex, columnIndex),
                              );
                            }).toList(),
                          );
                        }).toList(),
                      ),
                    ),
                    const Spacer()
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
