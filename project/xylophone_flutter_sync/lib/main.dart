import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:xylophone/key_note.dart';

import 'services/signal_r_client_service.dart';
// import 'package:audioplayers/audio_cache.dart';

void main() => runApp(XylophoneApp());

class XylophoneApp extends StatefulWidget {
  @override
  State<XylophoneApp> createState() => _XylophoneAppState();
}

class _XylophoneAppState extends State<XylophoneApp> {
  HubConnection connection;

  // List<KeyNote> keyNotes = [
  Widget NoteKey({int keyNumber, Color keyColor}) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          print('note$keyNumber.wav');
          // final player = new AudioCache();
          // final player = AudioPlayer();
          // player.play('note$keyNumber.wav');
          // player.setSource(AssetSource('note$keyNumber.wav'));
          // player.play(AssetSource('note$keyNumber.wav'));
          // print('$keyNumber');

          connection.invoke("PressKey", args: ["user", "$keyNumber"]);
        },
        style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.all(0.0)),
          // backgroundColor: MaterialStateProperty.all(Colors.red),
        ),
        child: Container(color: keyColor),
      ),
    );
  }

  void _handleAClientProvidedFunction(List<Object> parameters) {
    // print("Server invoked the method");
    print(parameters[1]);
    final player = AudioPlayer();
    player.play(AssetSource('note${parameters[1]}.wav'));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SignalRClientService.main();

    connection = SignalRClientService.hubConnection;

    connection.on("ReceiveMessage", _handleAClientProvidedFunction);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Column(
            children: [
              NoteKey(
                keyNumber: 1,
                keyColor: Colors.red,
              ),
              NoteKey(
                keyNumber: 2,
                keyColor: Colors.orange,
              ),
              NoteKey(
                keyNumber: 3,
                keyColor: Colors.yellow,
              ),
              NoteKey(
                keyNumber: 4,
                keyColor: Colors.green,
              ),
              NoteKey(
                keyNumber: 5,
                keyColor: Colors.lightGreen,
              ),
              NoteKey(
                keyNumber: 6,
                keyColor: Colors.blue,
              ),
              NoteKey(
                keyNumber: 7,
                keyColor: Colors.purple,
              ),
              NoteKey(
                keyNumber: 8,
                keyColor: Colors.red,
              ),
              Visibility(
                visible: true,
                child: Container(
                  child: new RawKeyboardListener(
                    autofocus: true,
                    focusNode: new FocusNode(),
                    onKey: (input) {
                      print(input);
                      if (input is RawKeyDownEvent) {
                        try {
                          int keyInt = int.parse(input.logicalKey.keyLabel);
                          if (keyInt >= 1 && keyInt <= 8)
                          print(input.logicalKey.keyLabel); 
                          connection.invoke("PressKey", args: ["user", "$keyInt"]);
                        } catch (e) {
                          
                        }
                      }
                    },
                    child: Visibility(
                      visible: false, child: Text(""),
                    )
                    // new TextField(
                    //   // controller: new TextEditingController(),
                    // ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// class NoteKey extends StatelessWidget {
//   const NoteKey({Key key, this.keyNumber, this.keyColor}) : super(key: key);

//   final int keyNumber;
//   final Color keyColor;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Expanded(
//         child: ElevatedButton(
//           onPressed: () {
//             final player = new AudioCache();
//             player.play('note$keyNumber.wav');
//             // print('$keyNumber');
//           },
//           style: ButtonStyle(
//             padding: MaterialStateProperty.all(EdgeInsets.all(0.0)),
//             // backgroundColor: MaterialStateProperty.all(Colors.red),
//           ),
//           child: Expanded(
//             child: Container(color: keyColor),
//           ),
//         ),
//       ),
//     );
//   }
// }
