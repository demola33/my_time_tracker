import 'package:flutter/foundation.dart';

class TrueOrFalseSwitch with ChangeNotifier {
  bool value = false;

  void toggle() {
    value = !value;
    notifyListeners();
  }
}
