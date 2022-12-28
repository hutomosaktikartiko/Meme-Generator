import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomShimmer extends StatelessWidget {
  final double width, height;
  final ShapeBorder shapeBorder;

  const CustomShimmer.rectangular({
    Key? key,
    this.width = double.infinity,
    required this.height,
  })  : shapeBorder = const RoundedRectangleBorder(),
        super(key: key);

  const CustomShimmer.circular({
    Key? key,
    required this.width,
    required this.height,
    this.shapeBorder = const CircleBorder(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFEBEBF4),
      highlightColor: const Color(0xFFF4F4F4),
      child: Container(
        width: width,
        height: height,
        decoration: ShapeDecoration(
          shape: shapeBorder,
          color: const Color(0xFFEBEBF4),
        ),
      ),
    );
  }
}
