import 'package:flutter/material.dart';

import '../../../../../core/error/failure.dart';

class Error extends StatelessWidget {
  final Failure failure;

  const Error({
    super.key,
    required this.failure,
  });

  @override
  Widget build(BuildContext context) {
    return const Text("Error");
  }
}
