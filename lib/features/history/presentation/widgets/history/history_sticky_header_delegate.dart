import 'package:flutter/material.dart';

class HistoryStickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  const HistoryStickyHeaderDelegate({required this.child});

  final Widget child;

  static const double _headerHeight = 48.0;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    // Clamp the rendered height so it never exceeds what the viewport can paint.
    final double renderedHeight =
        (_headerHeight - shrinkOffset).clamp(minExtent, maxExtent);
    return SizedBox(height: renderedHeight, child: child);
  }

  @override
  double get maxExtent => _headerHeight;

  @override
  // minExtent must be ≤ the smallest paintExtent the viewport can provide.
  // Setting it to 0 prevents the SliverGeometry assertion that fires when
  // system UI (safe area / status bar) reduces paintExtent below minExtent.
  double get minExtent => 0;

  @override
  bool shouldRebuild(HistoryStickyHeaderDelegate oldDelegate) =>
      oldDelegate.child != child;
}
