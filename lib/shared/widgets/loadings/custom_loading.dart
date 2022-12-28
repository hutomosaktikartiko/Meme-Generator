import 'package:flutter/material.dart';

class CustomLoading {
  static loadingWithText(BuildContext context) {
    showDialog(
      context: context,
      builder: (contex) {
        return AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              Container(
                margin: const EdgeInsets.only(left: 7),
                child: const Text("Loading..."),
              ),
            ],
          ),
        );
      },
    );
  }
}
