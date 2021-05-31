import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ConnectivityProvider with ChangeNotifier {
  Connectivity _connectivity = Connectivity();
  bool _isOnline;
  bool get online => _isOnline;
 StreamController<bool> connectivityStatusController = StreamController<bool>();

  startMonitoring() async {
    await initConnectivity();
    _connectivity.onConnectivityChanged.listen(
      (result) async {
        print('result : $result');
        if (result == ConnectivityResult.none) {
          _isOnline = false;
          print('_isOnline: $_isOnline');
          print(online);
          notifyListeners();
        } else {
          _isOnline = await DataConnectionChecker().hasConnection;
          print('_isOnline: $_isOnline');
          print(online);
          notifyListeners();
        }
        connectivityStatusController.add(_isOnline);
      },
    );
  }


  Future<void> initConnectivity() async {
    ConnectivityResult status;
    try {
      status = await _connectivity.checkConnectivity();
      if (status == ConnectivityResult.none) {
        _isOnline = false;
        notifyListeners();
      } else {
        _isOnline = true;
        notifyListeners();
      }
    } catch (e) {
      print('initError: ${e.toString()}');
    }
    // return _connectionStatus(status);
  }

// Future<void> _connectionStatus(ConnectivityResult status) async {
//   switch (status) {
//     case ConnectivityResult.none:
//       _isOnline = false;
//       notifyListeners();
//       break;
//     case ConnectivityResult.mobile:
//       _isOnline = true;
//       break;
//     case ConnectivityResult.wifi:
//       _isOnline = true;
//       break;
//     default:
//       Get.snackbar('Network Error', 'Failed to get network connection');
//       break;
//   }
// }
checkDataConnection() async {
  print("The statement 'this machine is connected to the Internet' is: ");
  print(await DataConnectionChecker().hasConnection);
  // returns a bool

  // We can also get an enum value instead of a bool
  print("Current status: ${await DataConnectionChecker().connectionStatus}");
  // prints either DataConnectionStatus.connected
  // or DataConnectionStatus.disconnected

  // This returns the last results from the last call
  // to either hasConnection or connectionStatus
  print("Last results: ${DataConnectionChecker().lastTryResults}");

  // actively listen for status updates
  // this will cause DataConnectionChecker to check periodically
  // with the interval specified in DataConnectionChecker().checkInterval
  // until listener.cancel() is called
  var listener = DataConnectionChecker().onStatusChange.listen((status) {
    switch (status) {
      case DataConnectionStatus.connected:
        print('Data connection is available.');
        break;
      case DataConnectionStatus.disconnected:
        print('You are disconnected from the internet.');
        break;
    }
  });

  // close listener after 30 seconds, so the program doesn't run forever
  await Future.delayed(Duration(seconds: 30));
  await listener.cancel();
}
Future<bool> _updateConnectionStatus() async {
  bool isConnected;
  try {
    final List<InternetAddress> result =
        await InternetAddress.lookup('google.com');
    //print('result : $result');

    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      //print('result1 : $result');
      isConnected = true;
      notifyListeners();
    }
  } on SocketException catch (e) {
    print(e.toString());

    isConnected = false;
    notifyListeners();
  }
  return isConnected;
}
}
