import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:focus_detector/focus_detector.dart';
import 'dart:math';

import 'package:rock_paper_scissors_game/components/option_card.dart';

import '../components/player_card.dart';
import '../hubs/game_hub.dart';

enum GameStatus {
  waitingForOpponent,
  perparing,
  done,
}

enum Gesture { none, scissors, rock, paper }

extension ParseToString on Gesture {
  String toShortString() {
    return this.toString().split('.').last;
  }
}

class GamePage extends StatefulWidget {
  final bool isEnterRoom;
  final int roomId;
  final String roomName;
  const GamePage(
      {super.key,
      required this.roomId,
      required this.roomName,
      required this.isEnterRoom});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage>
    with SingleTickerProviderStateMixin {
  String opponentGestureName = "empty";
  String currentGestureName = "cover";
  Gesture currentGesture = Gesture.none;
  String caption = "Waiting for new opponent to enter the room";

  GameStatus gameStatus = GameStatus.waitingForOpponent;

  VoidCallback? disconnectCallback;

  AnimationController? rotationController;

  @override
  void initState() {
    super.initState();

    rotationController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    ;

    GameHub.hubConnection.onreconnecting(
      ({error}) {
        triggerDisconnectCallback();
      },
    );

    if (widget.isEnterRoom) // otherwise, it is create room
    {
      // in enter room, both player exist, the game can be start
      GameHub.hubConnection.invoke("EnterRoom", args: [widget.roomId]);
    }

    GameHub.hubConnection.on("GameStart", (args) {
      // print(json.encode(serverRooms?[0]));
      // print("GameStart");
      setState(() {
        gameStatus = GameStatus.perparing;
        opponentGestureName = "cover";
        caption = "Please select a shape";
      });
    });

    GameHub.hubConnection.on("OpponentSelectGesture", (args) {
      var opponentGestureIndex = json.decode(json.encode(args?[0]));
      // print("Gesture: ${newnew}, ${newnew.runtimeType}");
      // return;
      Gesture opponentGesture = Gesture.values[opponentGestureIndex];
      setState(() {
        gameStatus = GameStatus.done;
        // opponentGestureName = opponentGesture.toShortString();
        rotationController?.forward(from: 0.0);

        Future.delayed(Duration(milliseconds: 250), () {
          setState(() {
            // newGesture += "_reverse";
            opponentGestureName = opponentGesture.toShortString() + "_reverse";
          });
        });
        Future.delayed(Duration(milliseconds: 500), () {
          setState(() {
            if (currentGesture == opponentGesture) {
              caption = "It is a Tie!";
            } else if (currentGesture == Gesture.paper) {
              if (opponentGesture == Gesture.rock) {
                caption = "You Win!";
              } else if (opponentGesture == Gesture.scissors) {
                caption = "You Lose!";
              }
            } else if (currentGesture == Gesture.rock) {
              if (opponentGesture == Gesture.scissors) {
                caption = "You Win!";
              } else if (opponentGesture == Gesture.paper) {
                caption = "You Lose!";
              }
            } else if (currentGesture == Gesture.scissors) {
              if (opponentGesture == Gesture.paper) {
                caption = "You Win!";
              } else if (opponentGesture == Gesture.rock) {
                caption = "You Lose!";
              }
            }
            opponentGestureName = opponentGesture.toShortString();
            rotationController!.value = 0;
          });
        });
      });
    });

    GameHub.hubConnection.on("RoomReset", (args) {
      // print(json.encode(serverRooms?[0]));
      showToast(
        'The opponent left the room.',
        duration: Duration(seconds: 3),
        context: context,
      );
      setState(() {
        gameStatus = GameStatus.waitingForOpponent;
        opponentGestureName = "empty";
        currentGestureName = "cover";
        currentGesture = Gesture.none;
        caption = "Waiting for new opponent to enter the room";
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    GameHub.hubConnection.off("GameStart");
    GameHub.hubConnection.off("OpponentSelectGesture");
    GameHub.hubConnection.off("RoomReset");
    GameHub.hubConnection.invoke("QuitRoom", args: [widget.roomId]);
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusGained: () {
        disconnectCallback = () {
          handleDisconnect();
        };
      },
      onFocusLost: () {
        // print("onFocusLost on game");
        disconnectCallback = null;
      },
      child: Scaffold(
        appBar: AppBar(
          // shadowColor: Color.fromRGBO(0, 0, 0, .7),
          // leading: IconButton(
          //   icon: Icon(Icons.arrow_back_ios),
          //   onPressed: () {
          //     Navigator.pop(context);
          //   },
          // ),
          title: FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(widget.roomName),
          ),
          // actions: [
          //   Visibility(
          //     visible: gameStatus == GameStatus.done,
          //     maintainState: true,
          //     maintainAnimation: true,
          //     maintainSize: true,
          //     child: IconButton(
          //       icon: Icon(Icons.replay),
          //       onPressed: () {
          //         restartGame();
          //       },
          //     ),
          //   )
          // ],
        ),
        body: SafeArea(
          bottom: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                flex: 4,
                child: Transform(
                  transform: Matrix4.rotationZ(
                    pi,
                  ),
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: AnimatedBuilder(
                      animation: rotationController!,
                      builder: (BuildContext context, Widget? child) {
                        return Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.001)
                            ..rotateY(
                              rotationController!.value * (pi),
                            ),
                          child: child,
                        );
                      },
                      child: PlayerCard(card: opponentGestureName),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        caption,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Color.fromRGBO(0, 0, 0, .4),
                              blurRadius: 12,
                              offset: Offset(0, 2), // Shadow position
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: PlayerCard(card: currentGestureName),
                ),
              ),
              Expanded(
                flex: 3,
                child: gameStatus == GameStatus.done
                    ? Center(
                        child: ElevatedButton(
                          onPressed: () {
                            restartGame();
                          },
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Text("Restart Game"),
                          ),
                        ),
                      )
                    : Row(
                        children: [
                          OptionCard(
                            isStarted: (gameStatus == GameStatus.perparing),
                            gesture: "paper",
                            onPress: () {
                              setState(() {
                                selectGesture(Gesture.paper);
                              });
                            },
                          ),
                          OptionCard(
                            isStarted: (gameStatus == GameStatus.perparing),
                            gesture: "rock",
                            onPress: () {
                              selectGesture(Gesture.rock);
                            },
                          ),
                          OptionCard(
                            isStarted: (gameStatus == GameStatus.perparing),
                            gesture: "scissors",
                            onPress: () {
                              setState(() {
                                selectGesture(Gesture.scissors);
                              });
                            },
                          ),
                        ],
                      ),
              )
            ],
          ),
        ),
        // floatingActionButton: Visibility(
        //   visible: gameStatus == GameStatus.done,
        //   maintainState: true,
        //   maintainAnimation: true,
        //   maintainSize: true,
        //   child: FloatingActionButton(
        //     onPressed: restartGame,
        //     child: Icon(Icons.replay),
        //     backgroundColor: Color(0xFF231917),
        //     // color: Colors.red,
        //     // splashColor: Colors.red,
        //   ),
        // ),
      ),
    );
  }

  void selectGesture(Gesture newGesture) {
    setState(() {
      currentGestureName = newGesture.toShortString();
      currentGesture = newGesture;
      // print("${newGesture.toShortString()}, ${newGesture.index}");
      caption = "Waiting for opponent to select a shape";
      GameHub.hubConnection
          .invoke("SelectGesture", args: [widget.roomId, newGesture.index]);
    });
  }

  void restartGame() {
    setState(() {
      opponentGestureName = "cover";
      currentGestureName = "cover";
      currentGesture = Gesture.none;
      caption = "Waiting for opponent to start a new game";

      gameStatus = GameStatus.waitingForOpponent;
    });
    GameHub.hubConnection.invoke("ResetRoom", args: [widget.roomId]);
  }

  void triggerDisconnectCallback() {
    // print("triggerDisconnectCallback at game");
    disconnectCallback?.call();
  }

  void handleDisconnect() {
    // print("handleDisconnect at game");
    showToast(
      'You are disconnected from the server.',
      duration: Duration(seconds: 5),
      context: context,
    );
    Navigator.pop(context);
    Navigator.pop(context);
  }
}
