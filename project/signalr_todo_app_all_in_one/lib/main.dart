import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:signalr_todo_app/models/todoItem.dart';
import 'widgets/todoItemCell.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  late HubConnection connection;

  List<ToDoItem> toDoItems = [new ToDoItem(id: 99, taskName: 'taskName')];

  Future<void> main(List<String>? arguments) async {
    connection = HubConnectionBuilder()
        .withUrl(
            'https://todo.lawlietstudio.com/todo',
            HttpConnectionOptions(
              client: IOClient(
                  HttpClient()..badCertificateCallback = (x, y, z) => true),
              // logging: (level, message) => print(message),
            ))
        .build();

    await connection.start();

    connection.on('alertMessageResonpse', (message) {
      print(message.toString());
    });

    connection.on('RefreshTodoItems', (newToDoItems) {
      print(newToDoItems![0][0]);
      print(newToDoItems![0][0]['id']);

      try {
        // toDoItems = List<ToDoItem>.from(newToDoItems[0] as List);

        toDoItems = [];
        newToDoItems[0].forEach((element) {
          // ToDoItem toDoItem = json.decode(element).cast<ToDoItem>();

          ToDoItem toDoItem = ToDoItem(id: element['id'], taskName: element['taskName']);
          setState(() {
            toDoItems.add(toDoItem);
          });
        });
        print(toDoItems[0].taskName);
      } catch (e) {
        print(e);
      }
      // print("runtimeType ${newToDoItems.runtimeType}");
      // String dataString = newToDoItems.toString();
      // print('dataString: $dataString');
      // print("dataString runtimeType ${dataString.runtimeType}");
      // var data = jsonDecode(dataString);
      // print("data runtimeType ${data.runtimeType}");
      // print('data: $data');
      // print("data: ${data[0]['taskName']}");
      // print(data[0]['taskName']);
      // print(newToDoItems.toString());
      // print(newToDoItems[0].toString());
      // setState(() {
      //   toDoItems = List<ToDoItem>.from(newToDoItems[0] as List);
      //   print(toDoItems.toString());
      // });
    });

    // var toDoItems = connection.invoke('GetAllTodoItems');
    // print("toDoItems");
    // print(toDoItems);

    connection.invoke('sendAlertMessage',
        args: ["nfGgUZBWE9NwfU2n3KVEIg", 'from flutter app']);

    // await connection.invoke('SendMessage', args: ['Bob', 'Says hi!']);
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    connection.stop();
    print(deactivate);
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    main(null);
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: toDoItems.isEmpty
              ? Text("data")
              : ListView.builder(
                  itemBuilder: (ctx, index) {
                    return ToDoItemCell(onDeleteItem: null, onToDoChanged: null, todo: toDoItems[index],);
                    // return Text(toDoItems[index].taskName);
                  },
                  itemCount: toDoItems.length,
                )),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
