import 'package:signalr_netcore/signalr_client.dart';

class GameHub {
  // mac
  // static var serverUrl = "http://192.168.5.31:5099/gamehub";
  // windows
  static var serverUrl = "https://prsgame.lawlietstudio.com/gamehub";
  // static var serverUrl = "http://192.168.5.40:5099/gamehub";

  static HubConnection hubConnection =
      HubConnectionBuilder().withUrl(serverUrl).build();

  static void registerDisconnection() {
    print("registerDisconnection ${ hubConnection.state }");
    hubConnection.onclose(({error}) {
      print("onclose");
    });
    hubConnection.onreconnected(({connectionId}) {
      print("onreconnected");
    });
    hubConnection.onreconnecting(({error}) {
      print("onreconnecting");
    });
  }

  static Future connect() async {
    // final serverUrl = "https://xylophone.lawlietstudio.com/synchub";

    // Creates the connection by using the HubConnectionBuilder.
    hubConnection = HubConnectionBuilder().withUrl(serverUrl).build();
// When the connection is closed, print out a message to the console.
// final hubConnection.onclose( (error) => print("Connection Closed"));

    // final result = hubConnection.invoke(
    //     "MethodOneSimpleParameterSimpleReturnValue",
    //     args: <Object>["ParameterValue"]);

    // hubConnection?.on("ReceiveMessage", _handleAClientProvidedFunction);

    // To unregister the function use:
    // a) to unregister a specific implementation:
    // hubConnection.off("aClientProvidedFunction", method: _handleServerInvokeMethodNoParametersNoReturnValue);
    // b) to unregister all implementations:
    // hubConnection.off("aClientProvidedFunction");
  }
}
