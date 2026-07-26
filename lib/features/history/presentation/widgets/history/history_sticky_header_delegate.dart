import 'package:flutter/material.dart';

class HistoryStickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  const HistoryStickyHeaderDelegate({required this.child});

  final Widget child;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  double get maxExtent => 48;

  @override
  double get minExtent => 48;

  @override
  bool shouldRebuild(HistoryStickyHeaderDelegate oldDelegate) =>
      oldDelegate.child != child;
}
