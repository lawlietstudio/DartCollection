import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';

void main() => runApp(XylophoneApp());

class XylophoneApp extends StatelessWidget {
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
            ],
          ),
        ),
      ),
    );
  }
}

class NoteKey extends StatelessWidget {
  const NoteKey({Key key, this.keyNumber, this.keyColor}) : super(key: key);

  final int keyNumber;
  final Color keyColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Expanded(
        child: ElevatedButton(
          onPressed: () {
            final player = new AudioCache();
            player.play('note$keyNumber.wav');
            // print('$keyNumber');
          },
          style: ButtonStyle(
            padding: MaterialStateProperty.all(EdgeInsets.all(0.0)),
            // backgroundColor: MaterialStateProperty.all(Colors.red),
          ),
          child: Expanded(
            child: Container(color: keyColor),
          ),
        ),
      ),
    );
  }
}
