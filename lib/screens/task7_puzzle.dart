import 'package:flutter/material.dart';

class PuzzleGame extends StatefulWidget {
  const PuzzleGame({Key? key}) : super(key: key);

  @override
  _PuzzleGameState createState() => _PuzzleGameState();
}

class _PuzzleGameState extends State<PuzzleGame> {
  int emptyBoxIndex = 5;
  int grid = 4;
  int move = 0;

  List<int?> numBox = [];

  @override
  void initState() {
    super.initState();
    buildPuzzle();
  }

  buildPuzzle() {
    int count = 0;
    for (var i = 0; i < grid * grid; i++) {
      if (i == emptyBoxIndex) {
        numBox.add(null);
      } else {
        numBox.add(count + 1);
        count++;
      }
    }
    numBox.shuffle();
    emptyBoxIndex = numBox.indexOf(null);
  }

  swap(int index) {
    int? temp = numBox[index];
    numBox[emptyBoxIndex] = temp;
    numBox[index] = null;
    emptyBoxIndex = index;
    move++;
    setState(() {});
  }

  _onTap(int index) async {
    int? elementValue = index + 1;
    int? elementPosition = index;

    if ([(elementPosition + grid), (elementPosition - grid)]
        .contains(emptyBoxIndex)) {
      swap(index);
    } else if (((elementPosition + 1) == emptyBoxIndex) &&
        (elementValue % grid != 0)) {
      swap(index);
    } else if ((elementPosition - 1) == emptyBoxIndex &&
        (elementValue % grid != 1)) {
      swap(index);
    }

    if (checkWinner()) {
      await showDialog(
          context: context,
          builder: (context) => const AlertDialog(
                title: Text("You won!!"),
              ));
    }
  }

  void reset() {
    numBox.clear();
    buildPuzzle();
    setState(() {});
  }

  bool checkWinner() {
    bool win = true;
    for (var i = 0; i < numBox.length; i++) {
      if (((i + 1) != numBox[i]) && (numBox[i] != null)) {
        win = false;
        break;
      }
    }
    return win;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.purple[50],
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(primary: Colors.deepPurple),
                  onPressed: reset,
                  icon: const Icon(Icons.restart_alt),
                  label: const Text("Reset")),
              const SizedBox(
                height: 30.0,
              ),
              SizedBox(
                width: 300,
                height: 500,
                child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: grid,
                        crossAxisSpacing: 4,
                        mainAxisSpacing: 4),
                    itemCount: numBox.length,
                    itemBuilder: (context, index) => GestureDetector(
                          onTap: () => _onTap(index),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.deepPurpleAccent,
                                borderRadius: BorderRadius.circular(5)),
                            child: Center(
                              child: Text(
                                numBox[index] == null
                                    ? ""
                                    : numBox[index].toString(),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 35.0),
                              ),
                            ),
                          ),
                        )),
              ),
              Text(
                "Move : $move",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
