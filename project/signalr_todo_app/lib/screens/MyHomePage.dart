import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:signalr_core/signalr_core.dart';

import '../models/todoItem.dart';
import '../services/SignalRClient.dart';
import '../widgets/todoItemCell.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  HubConnection? connection;

  List<ToDoItem> toDoItems = [new ToDoItem(id: 99, taskName: 'taskName')];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    startConnection();
  }

  Future<void> startConnection() async {
    await SignalRClient.main(null);

    connection = SignalRClient.connection;

    connection?.invoke('GetAllTodoItems', args: []).then((newToDoItems) {
      print(newToDoItems);
      buildToDoList(newToDoItems);
    });
    connection?.invoke('sendAlertMessage',
        args: ["rF-BqtziEu1Cq7V90xia2w", 'from flutter app']);

    connection?.on('alertMessageResonpse', (message) {
      print(message.toString());
    });

    connection?.on('RefreshTodoItems', (newToDoItems) {
      print(json.encode(newToDoItems));
      print(newToDoItems![0][0]);
      print(newToDoItems[0][0]['id']);

      buildToDoList(newToDoItems[0]);
    });
  }

  void buildToDoList(List<dynamic> newToDoItems) {
    try {
      // toDoItems = List<ToDoItem>.from(newToDoItems[0] as List);

      toDoItems = [];
      newToDoItems.forEach((element) {
        // ToDoItem toDoItem = json.decode(element).cast<ToDoItem>();

        ToDoItem toDoItem =
            ToDoItem(id: element['id'], taskName: element['taskName']);
        setState(() {
          toDoItems.add(toDoItem);
        });
      });
      print(toDoItems[0].taskName);
    } catch (e) {
      print(e);
    }
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    connection?.stop();
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
                    return ToDoItemCell(
                      onDeleteItem: null,
                      onToDoChanged: null,
                      todo: toDoItems[index],
                    );
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
