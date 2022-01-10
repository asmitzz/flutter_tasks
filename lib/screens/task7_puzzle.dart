import 'package:flutter/material.dart';

class PuzzleGame extends StatefulWidget {
  const PuzzleGame({Key? key}) : super(key: key);

  @override
  _PuzzleGameState createState() => _PuzzleGameState();
}

class _PuzzleGameState extends State<PuzzleGame> {
  List<int?> numBox = [1, 2, 3, 4, 5, null, 6, 7, 8];
  int emptyBoxIndex = 5;
  int grid = 3;

  _onTap(int index) async {
    if ([(index - 1), (index + 1), (index + grid), (index - grid)]
        .contains(emptyBoxIndex)) {
      int? temp = numBox[index];
      numBox[emptyBoxIndex] = temp;
      numBox[index] = null;
      emptyBoxIndex = index;
      setState(() {});
    }

    if (checkWinner()) {
      var res = await showDialog(
          context: context,
          builder: (context) => const AlertDialog(
                title: Text("You won!!"),
              ));

      if (res == null) {
        numBox = [1, 2, 3, 4, 5, 6, 7, null, 8];
        emptyBoxIndex = 5;
        setState(() {});
      }
    }
  }

  bool checkWinner() {
    bool win = true;
    for (var i = 0; i < numBox.length; i++) {
      if (((i + 1) != numBox[i]) && (numBox[i] != null)) {
        win = false;
        print(numBox[i]);
        break;
      }
    }
    return win;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SizedBox(
            height: 300,
            width: 300,
            child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 100,
                    childAspectRatio: 3 / 2,
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
        ),
      ),
    );
  }
}
