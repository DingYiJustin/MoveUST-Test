import 'package:flutter/material.dart';

class SizeConfig {
  static late MediaQueryData _windowSize;
  static late double _screenWidth;
  static late double _screenHeight;
  static late double _safeAreaWidth;
  static late double _safeAreaHeight;
  ///width per block
  static late double wBlock;
  ///height per block
  static late double hBlock;

  void init(BuildContext context) {
    _windowSize = MediaQuery.of(context);
    _screenWidth = _windowSize.size.width;
    _screenHeight = _windowSize.size.height;
    _safeAreaWidth = _screenWidth - (_windowSize.padding.left + _windowSize.padding.right);
    _safeAreaHeight = _screenHeight - ( _windowSize.padding.top + _windowSize.padding.bottom);
    wBlock = _safeAreaWidth / 100;
    hBlock = _safeAreaHeight / 100;
  }
}
