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

class _GamePageState extends State<GamePage> {
  String opponentGestureName = "empty";
  String currentGestureName = "cover";
  Gesture currentGesture = Gesture.none;
  String caption = "Waiting for new opponent to enter the room";

  GameStatus gameStatus = GameStatus.waitingForOpponent;

  VoidCallback? disconnectCallback;

  @override
  void initState() {
    super.initState();

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
        caption = "Please select a gesture";
      });
    });

    GameHub.hubConnection.on("OpponentSelectGesture", (args) {
      var opponentGestureIndex = json.decode(json.encode(args?[0]));
      // print("Gesture: ${newnew}, ${newnew.runtimeType}");
      // return;
      Gesture opponentGesture = Gesture.values[opponentGestureIndex];
      setState(() {
        gameStatus = GameStatus.done;
        opponentGestureName = opponentGesture.toShortString();
        if (currentGesture == opponentGesture) {
          caption = "You Draw!";
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
          shadowColor: Color.fromRGBO(0, 0, 0, .7),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              GameHub.hubConnection.invoke("QuitRoom", args: [widget.roomId]);
              Navigator.pop(context);
            },
          ),
          title: FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(widget.roomName),
          ),
          actions: [
            Visibility(
              visible: gameStatus == GameStatus.done,
              maintainState: true,
              maintainAnimation: true,
              maintainSize: true,
              child: IconButton(
                icon: Icon(Icons.replay),
                onPressed: () {
                  restartGame();
                },
              ),
            )
          ],
        ),
        body: SafeArea(
          bottom: true,
          child: Container(
            child: Column(
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
                      child: PlayerCard(card: opponentGestureName),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Text(caption),
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
        ),
      ),
    );
  }

  void selectGesture(Gesture newGesture) {
    setState(() {
      currentGestureName = newGesture.toShortString();
      currentGesture = newGesture;
      // print("${newGesture.toShortString()}, ${newGesture.index}");
      caption = "Waiting for opponent to select a gesture";
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
