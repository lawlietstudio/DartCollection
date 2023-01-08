import 'package:flutter/material.dart';
import 'package:rock_paper_scissors_game/hubs/game_hub.dart';
import 'package:rock_paper_scissors_game/pages/room_page.dart';
import 'package:signalr_netcore/signalr_client.dart';

import '../components/player_card.dart';
import 'dart:math';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  AnimationController? rotationController;
  String gesture = "cover";
  int oldCard = -1;

  void connectToServer() async {
    // print("connectToServer ${GameHub.hubConnection.state}");

    if (GameHub.hubConnection.state == HubConnectionState.Connected) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => RoomPage()));
    } else {
      GameHub.hubConnection.start()?.then((value) {
        GameHub.registerDisconnection();
        // print("Connected");
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => RoomPage()));
      }).onError((error, stackTrace) {
        // print("Connect fail: $error");
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Message"),
                content: Text("Connect fail: $error"),
                actions: [
                  TextButton(
                      onPressed: () => {Navigator.pop(context, 'OK')},
                      child: Text("OK"))
                ],
              );
            });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    rotationController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PRS Game',
          style: TextStyle(fontFamily: "SkullphabetOne"),
        ),
        // shadowColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {
              // createRoom();
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    // insetPadding: EdgeInsets.all(200),
                    // icon: Icon(Icons.add),
                    clipBehavior: Clip.hardEdge,
                    title: Text("Scan the QR code and go to the web version:"),
                    content: Image.asset("images/qrcode.png"),
                  );
                },
              );
            },
            icon: Icon(Icons.qr_code_2_sharp),
          )
        ],
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Spacer(),
          Expanded(
            flex: 2,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(48.0),
                child: GestureDetector(
                  onTap: () {
                    // print("tap");
                    if (rotationController!.value != 0) {
                      return;
                    }
                    rotationController?.forward(from: 0.0);
                    setState(() {
                      int nextCard = Random().nextInt(3);
                      while (nextCard == oldCard) {
                        nextCard = Random().nextInt(3);
                      }
                      oldCard = nextCard;
                      // print(nextCard);
                      String newGesture = "";
                      switch (oldCard) {
                        case 0:
                          newGesture = "paper";
                          break;
                        case 1:
                          newGesture = "rock";
                          break;
                        case 2:
                          newGesture = "scissors";
                          break;
                        default:
                      }
                      Future.delayed(Duration(milliseconds: 250), () {
                        setState(() {
                          // newGesture += "_reverse";
                          gesture = newGesture + "_reverse";
                        });
                      });
                      Future.delayed(Duration(milliseconds: 500), () {
                        setState(() {
                          gesture = newGesture;
                          rotationController!.value = 0;
                        });
                      });
                    });
                  },
                  child: AnimatedBuilder(
                    // alignment: Alignment.topLeft,
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
                    child: PlayerCard(card: gesture),
                  ),
                ),
              ),
            ),
          ),
          Container(
            child: FittedBox(
              fit: BoxFit.contain,
              child: Text(
                "Paper Rock Scissors Game",
                style: TextStyle(
                  fontFamily: "SkullphabetOne",
                  fontSize: 24,
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
          Spacer(),
          // const Text(
          //   'Paper Rock Scissors Game',
          //   style: TextStyle(
          //     fontSize: 20,
          //   ),
          // ),
          // Expanded(
          //   // flex: 2,
          //   child: Center(
          //     child: ElevatedButton(
          //       onPressed: connectToServer,
          //       child: Text("Connect to Server"),
          //     ),
          //   ),
          // ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: connectToServer,
        child: Icon(Icons.upload),
        backgroundColor: Color(0xFF231917),
        // color: Colors.red,
        // splashColor: Colors.red,
      ),
    );
  }
}
