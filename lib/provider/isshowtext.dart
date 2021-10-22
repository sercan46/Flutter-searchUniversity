import 'package:flutter/material.dart';

class IsShowTextField with ChangeNotifier {
  bool _isShowText = false;

  bool get isShowText => _isShowText;

  set isShowText(bool isShowText) {
    _isShowText = isShowText;
    notifyListeners();
  }
}
