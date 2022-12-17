import 'dart:io';

import 'package:http/io_client.dart';
import 'package:signalr_core/signalr_core.dart';

class SignalRClient
{
  static HubConnection? connection;

  static Future<void> main(List<String>? arguments) async {
    connection = HubConnectionBuilder()
        .withUrl(
            'https://todo.lawlietstudio.com/todo',
            HttpConnectionOptions(
              client: IOClient(
                  HttpClient()..badCertificateCallback = (x, y, z) => true),
              // logging: (level, message) => print(message),
            ))
        .build();

    await connection?.start();

    // var toDoItems = connection.invoke('GetAllTodoItems');
    // print("toDoItems");
    print("start");

    // connection?.invoke('sendAlertMessage',
    //     args: ["rF-BqtziEu1Cq7V90xia2w", 'from flutter app']);

    print("sendAlertMessage");

    // await connection.invoke('SendMessage', args: ['Bob', 'Says hi!']);
  }
}