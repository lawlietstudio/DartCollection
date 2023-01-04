import 'package:flutter/material.dart';
import 'package:rock_paper_scissors_game/hubs/game_hub.dart';
import 'package:rock_paper_scissors_game/pages/room_page.dart';
import 'package:signalr_netcore/signalr_client.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void connectToServer() async {
    // print("connectToServer ${GameHub.hubConnection.state}");

    if (GameHub.hubConnection.state == HubConnectionState.Connected) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => RoomPage()));
    } else {
      GameHub.hubConnection.start()?.then((value) {
        // GameHub.registerDisconnection();
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Paper Rock Scissors Game'),
        shadowColor: Colors.transparent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // const Text(
            //   'Paper Rock Scissors Game',
            //   style: TextStyle(
            //     fontSize: 20,
            //   ),
            // ),
            ElevatedButton(
              onPressed: connectToServer,
              child: Text("Connect to Server"),
            ),
          ],
        ),
      ),
    );
  }
}
