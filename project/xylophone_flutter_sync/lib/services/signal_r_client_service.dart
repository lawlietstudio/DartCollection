import 'package:signalr_netcore/signalr_client.dart';

class SignalRClientService {
  static HubConnection hubConnection;

  static void main() {
    final serverUrl = "https://xylophone.lawlietstudio.com/synchub";
// Creates the connection by using the HubConnectionBuilder.
    hubConnection = HubConnectionBuilder().withUrl(serverUrl).build();
// When the connection is closed, print out a message to the console.
// final hubConnection.onclose( (error) => print("Connection Closed"));

    hubConnection.start();

    // final result = hubConnection.invoke(
    //     "MethodOneSimpleParameterSimpleReturnValue",
    //     args: <Object>["ParameterValue"]);

    // hubConnection.on("ReceiveMessage", _handleAClientProvidedFunction);

    // To unregister the function use:
    // a) to unregister a specific implementation:
    // hubConnection.off("aClientProvidedFunction", method: _handleServerInvokeMethodNoParametersNoReturnValue);
    // b) to unregister all implementations:
    // hubConnection.off("aClientProvidedFunction");
  }

  // static void _handleAClientProvidedFunction(List<Object> parameters) {
  //   print("Server invoked the method");
  //   print(parameters);
  // }
}
