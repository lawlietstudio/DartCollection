import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 245, 218, 123),
        // appBar: AppBar(
        //   title: const Text('data'),
        //   backgroundColor: Colors.blueGrey[500],
        // ),
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              Expanded(
                child: const Image(
                  image: AssetImage(
                    "images/3d-hands-fun-and-wild-fist-of-a-brown-skin-hand-raised.png",
                  ),
                ),
              ),
              Expanded(
                child: const Image(
                  image: AssetImage(
                    "images/3d-hands-fun-and-wild-pale-skin-hand-showing-v-sign-1.png",
                  ),
                ),
              ),
              Expanded(
                child: const Image(
                  image: AssetImage(
                    "images/3d-hands-fun-and-wild-pale-skin-hand-waving-hello-1.png",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
