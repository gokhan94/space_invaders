import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Game(),
    );
  }
}

class Game extends StatefulWidget {
  @override
  _GameState createState() => _GameState();
}

final invader1 = List<String>.filled(15, "images/invader4.png");
final invader2 = List<String>.filled(15, "images/invader3.png");
final invader3 = List<String>.filled(15, "images/invader2.png");
final invader4 = List<String>.filled(15, "images/invader1.png");
final invader5 = List<String>.filled(15, "images/invader1.png");

class _GameState extends State<Game> {
// 45 indis number
  final List<int> invaderListCoordinate = [
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    18,
    19,
    20,
    21,
    22,
    23,
    24,
    25,
    26,
    33,
    34,
    35,
    36,
    37,
    38,
    39,
    40,
    41,
    48,
    49,
    50,
    51,
    52,
    53,
    54,
    55,
    56,
    63,
    64,
    65,
    66,
    67,
    68,
    69,
    70,
    71
  ];
  final List<int> spaceShipCoordinate = [247];
  final List<int> bullet = [];
  final List<String> imageArray = [
    ...invader1,
    ...invader2,
    ...invader3,
    ...invader4,
    ...invader5
  ];

  void gameStart() {
    Timer.periodic(Duration(milliseconds: 600), (timer) {
      alienMovies();
    });
  }

  String direction = "right";

  void alienMovies() {
    setState(() {
      if ((invaderListCoordinate[0] - 1) % 15 == 0) {
        direction = "right";
      } else if ((invaderListCoordinate.last + 2) % 15 == 0) {
        direction = "left";
      }

      if (direction == "right") {
        for (int i = 0; i < invaderListCoordinate.length; i++) {
          invaderListCoordinate[i] += 1;
        }
      } else {
        for (int i = 0; i < invaderListCoordinate.length; i++) {
          invaderListCoordinate[i] -= 1;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.only(top: 20),
                color: Colors.redAccent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "SCORE : 0",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "LIVES : 0",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              )),
          Expanded(
            flex: 8,
            child: gameBoard(),
          ),
          Expanded(
              flex: 1,
              child: Container(
                color: Colors.grey.shade800,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: 120,
                      child: RaisedButton(
                        child: Icon(
                          Icons.arrow_left,
                          size: 40,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          spaceMoveLeft();
                        },
                      ),
                    ),
                    SizedBox(
                      width: 120,
                      child: RaisedButton(
                        child: Icon(
                          Icons.local_fire_department,
                          size: 40,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          burn();
                        },
                      ),
                    ),
                    SizedBox(
                      width: 120,
                      child: RaisedButton(
                        child: Icon(
                          Icons.arrow_right,
                          size: 40,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          gameStart();
                        },
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget gameBoard() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 15, crossAxisSpacing: 2.0),
      itemBuilder: (BuildContext ctx, int index) {
        if (invaderListCoordinate.contains(index)) {
          return Padding(
              padding: EdgeInsets.all(1),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  color: Colors.black,
                  child: Center(
                      child: CircleAvatar(
                    child: Image.asset(imageArray[index]),
                    backgroundColor: Colors.transparent,
                  )),
                ),
              ));
        } else if (spaceShipCoordinate.contains(index)) {
          return Image.asset('images/invader.png');
        } else if (bullet.contains(index)) {
          return Container(
            color: Colors.green,
          );
        } else {
          return Padding(
              padding: EdgeInsets.all(1),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  color: Colors.black,
                  child: Center(child: Text("boş")),
                ),
              ));
        }
      },
      itemCount: 300,
    );
  }

  void burn() {
    Timer.periodic(Duration(milliseconds: 150), (timer) {
      setState(() {
        for (int i = 0; i < bullet.length; i++) {
          bullet[i] -= 15;

          var collisionInvaders = invaderListCoordinate.contains(bullet[i]);

          if (collisionInvaders || bullet[i] < 0) {
            invaderListCoordinate.removeWhere((invader) => invader == bullet[i]);
            //bullet removed
            bullet.removeAt(0);
            timer.cancel();
          }
        }
      });
    });

    spaceShipCoordinateBullet();
  }

  void spaceShipCoordinateBullet() {
    var current;

    setState(() {
      for (int i = 0; i < spaceShipCoordinate.length; i++) {
        current = spaceShipCoordinate[i];
        bullet.add(current);
        return current;
      }
    });
    print(bullet);
  }

  int leftCurrentShip;
  void spaceMoveLeft() {
    setState(() {
      for (int i = 0; i < spaceShipCoordinate.length; i++) {
        spaceShipCoordinate[i] -= 1;
        leftCurrentShip = spaceShipCoordinate[i];
      }
    });
  }

  int rightCurrentShip;
  void spaceMoveRight() {
    setState(() {
      for (int i = 0; i < spaceShipCoordinate.length; i++) {
        spaceShipCoordinate[i] += 1;
        rightCurrentShip = spaceShipCoordinate[i];
      }
    });
  }
}
