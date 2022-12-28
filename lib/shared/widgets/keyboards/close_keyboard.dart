import 'package:flutter/material.dart';

class CloseKeyboard {
  static close(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }
}