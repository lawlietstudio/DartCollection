import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:rock_paper_scissors_game/pages/game_page.dart';

import '../cells/room_cell.dart';
import '../hubs/game_hub.dart';
import '../models/room.dart';

class RoomPage extends StatefulWidget {
  const RoomPage({super.key});

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  List<RoomInfo> rooms = [];
  VoidCallback? disconnectCallback;

  @override
  void initState() {
    super.initState();
    GameHub.hubConnection.on("RoomUpdate", (serverRooms) {
      // print(json.encode(serverRooms?[0]));
      // print("RoomUpdate");
      String serverRoomsStr = json.encode(serverRooms?[0]);
      updateRoomWithString(serverRoomsStr);
    });

    // GameHub.hubConnection.onclose(
    //   ({error}) {
    //     triggerDisconnectCallback();
    //   },
    // );

    GameHub.hubConnection.onreconnecting(
      ({error}) {
        triggerDisconnectCallback();
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    // print("dispose at room page");
    GameHub.hubConnection.off("RoomUpdate");
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusGained: () {
        getRooms();
        disconnectCallback = () {
          handleDisconnect();
        };
      },
      onFocusLost: () {
        // print("onFocusLost on room");
        disconnectCallback = null;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text("Lobby"),
          actions: [
            IconButton(
              onPressed: () {
                createRoom();
              },
              icon: Icon(Icons.add),
            )
          ],
        ),
        body: Column(
          children: [
            Expanded(
              flex: 4,
              child: rooms.isEmpty
                  ? Center(child: Text("No Room"))
                  : ListView.builder(
                      itemBuilder: (ctx, index) {
                        return RoomCell(
                          // onDeleteItem: null,
                          // onToDoChanged: null,
                          room: rooms[index],
                          onPress: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => GamePage(
                                          isEnterRoom: true,
                                          roomId: rooms[index].id,
                                          roomName: rooms[index].name,
                                        )));
                          },
                        );
                        // return Text(toDoItems[index].taskName);
                      },
                      itemCount: rooms.length,
                    ),
            ),
            Expanded(
                child: Center(
              child: ElevatedButton(
                onPressed: () {
                  createRoom();
                },
                child: Text("Create Room"),
              ),
            ))
          ],
        ),
      ),
    );
  }

  void createRoom() {
    GameHub.hubConnection.invoke("CreateRoom").then((newRoom) {
      // print("CreateRoom");
      RoomInfo room = RoomInfo.fromJson(json.decode(json.encode(newRoom)));
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => GamePage(
                  isEnterRoom: false,
                  roomId: room.id,
                  roomName: room.name,
                )),
      );
    });
  }

  void getRooms() {
    GameHub.hubConnection.invoke("GetRooms").then((serverRooms) {
      rooms = [];
      String serverRoomsStr = json.encode(serverRooms);
      // print(serverRoomsStr);
      updateRoomWithString(serverRoomsStr);
    });
  }

  void updateRoomWithString(String serverRoomsStr) {
    setState(() {
      rooms = (json.decode(serverRoomsStr) as List)
          .map((i) => RoomInfo.fromJson(i))
          .toList();
    });
  }

  void triggerDisconnectCallback() {
    // print("triggerDisconnectCallback at room");
    disconnectCallback?.call();
  }

  void handleDisconnect() {
    showToast(
      'You are disconnected from the server.',
      duration: Duration(seconds: 5),
      context: context,
    );
    // print("handleDisconnect at room");
    Navigator.pop(context);
  }
}
