import 'package:flutter/material.dart';

import 'pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Map<int, Color> color = {
      50: Color.fromRGBO(35, 25, 23, .1),
      100: Color.fromRGBO(35, 25, 23, .2),
      200: Color.fromRGBO(35, 25, 23, .3),
      300: Color.fromRGBO(35, 25, 23, .4),
      400: Color.fromRGBO(35, 25, 23, .5),
      500: Color.fromRGBO(35, 25, 23, .6),
      600: Color.fromRGBO(35, 25, 23, .7),
      700: Color.fromRGBO(35, 25, 23, .8),
      800: Color.fromRGBO(35, 25, 23, .9),
      900: Color.fromRGBO(35, 25, 23, 1),
    };
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      // theme: ThemeData.light().copyWith(
      //   primaryColor: Color(0xFF0A0E21),
      //   scaffoldBackgroundColor: Color(0xFF0A0E21),
      // ),
      theme: ThemeData(
        fontFamily: "SkullphabetOne",
        primarySwatch: MaterialColor(0xFF231917, color),
      ),
      home: const HomePage(),
    );
  }
}
