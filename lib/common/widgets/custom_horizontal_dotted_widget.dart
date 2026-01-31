import 'package:flutter/material.dart';

class CustomHorizontalDottedWidget extends StatelessWidget {
  final int numberOfDashes;
  final double dashWidth;
  final double dashHeight;
  final double horizontalPadding;
  final Color dashColor;

  const CustomHorizontalDottedWidget({
    super.key,
    this.numberOfDashes = 20, // Number of dashes
    this.dashWidth = 10.0, // Width of each dash
    this.dashHeight = 2.0, // Height of each dash
    this.horizontalPadding = 16.0, // Padding on left and right sides
    this.dashColor = Colors.black, // Color of the dashes
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double totalWidth = constraints.maxWidth - (horizontalPadding * 2);
        int adjustedDashes = numberOfDashes.clamp(1, (totalWidth / dashWidth).floor());
        double spaceBetweenDashes = ((totalWidth - (dashWidth * adjustedDashes)) / (adjustedDashes - 1)).clamp(0, double.infinity);

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(adjustedDashes, (index) {
              return Row(children: [
                Container(width: dashWidth, height: dashHeight, color: dashColor),
                if (index < adjustedDashes - 1) SizedBox(width: spaceBetweenDashes),
              ]);
            }),
          ),
        );
      },
    );
  }
}