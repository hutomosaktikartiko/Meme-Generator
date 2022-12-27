import 'package:flutter/material.dart';

import '../../../../../shared/widgets/custom_shimmer.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Wrap(
        spacing: 5,
        runSpacing: 5,
        alignment: WrapAlignment.center,
        children: List.generate(
          21,
          (_) => _buildCard(context),
        ).toList(),
      ),
    );
  }

  Widget _buildCard(BuildContext context) {
    return CustomShimmer.rectangular(
      width: MediaQuery.of(context).size.width / 3.5,
      height: MediaQuery.of(context).size.width / 3.5,
    );
  }
}
