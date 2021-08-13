import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/foundation.dart';

class ConnectivityProvider with ChangeNotifier {
  Connectivity _connectivity = Connectivity();
  bool _isOnline;
  bool get online => _isOnline;
  StreamController<bool> connectivityStatusController =
      StreamController<bool>();

  startMonitoring() async {
    await initConnectivity();
    _connectivity.onConnectivityChanged.listen(
      (result) async {
        if (result == ConnectivityResult.none) {
          _isOnline = false;
          notifyListeners();
        } else {
          _isOnline = await DataConnectionChecker().hasConnection;
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
  }
}
