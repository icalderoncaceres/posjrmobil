import 'package:flutter/material.dart';

class CustomSliverHeaderDelegateWidget extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  CustomSliverHeaderDelegateWidget({required this.child, this.height = 100});

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox(height: height, child: child);
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}