// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [DashboardScreen]
class DashboardRoute extends PageRouteInfo<void> {
  const DashboardRoute({List<PageRouteInfo>? children})
    : super(DashboardRoute.name, initialChildren: children);

  static const String name = 'DashboardRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const DashboardScreen();
    },
  );
}

/// generated route for
/// [HistoryScreen]
class HistoryRoute extends PageRouteInfo<void> {
  const HistoryRoute({List<PageRouteInfo>? children})
    : super(HistoryRoute.name, initialChildren: children);

  static const String name = 'HistoryRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HistoryScreen();
    },
  );
}

/// generated route for
/// [JoinFlatScreen]
class JoinFlatRoute extends PageRouteInfo<void> {
  const JoinFlatRoute({List<PageRouteInfo>? children})
    : super(JoinFlatRoute.name, initialChildren: children);

  static const String name = 'JoinFlatRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const JoinFlatScreen();
    },
  );
}

/// generated route for
/// [JoinOrCreateFlatScreen]
class JoinOrCreateFlatRoute extends PageRouteInfo<void> {
  const JoinOrCreateFlatRoute({List<PageRouteInfo>? children})
    : super(JoinOrCreateFlatRoute.name, initialChildren: children);

  static const String name = 'JoinOrCreateFlatRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const JoinOrCreateFlatScreen();
    },
  );
}

/// generated route for
/// [LoginScreen]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LoginScreen();
    },
  );
}

/// generated route for
/// [MonthDetailScreen]
class MonthDetailRoute extends PageRouteInfo<MonthDetailRouteArgs> {
  MonthDetailRoute({
    Key? key,
    required String monthId,
    MonthSummaryEntity? summary,
    List<PageRouteInfo>? children,
  }) : super(
         MonthDetailRoute.name,
         args: MonthDetailRouteArgs(
           key: key,
           monthId: monthId,
           summary: summary,
         ),
         rawPathParams: {'monthId': monthId},
         initialChildren: children,
       );

  static const String name = 'MonthDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<MonthDetailRouteArgs>(
        orElse: () =>
            MonthDetailRouteArgs(monthId: pathParams.getString('monthId')),
      );
      return MonthDetailScreen(
        key: args.key,
        monthId: args.monthId,
        summary: args.summary,
      );
    },
  );
}

class MonthDetailRouteArgs {
  const MonthDetailRouteArgs({this.key, required this.monthId, this.summary});

  final Key? key;

  final String monthId;

  final MonthSummaryEntity? summary;

  @override
  String toString() {
    return 'MonthDetailRouteArgs{key: $key, monthId: $monthId, summary: $summary}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! MonthDetailRouteArgs) return false;
    return key == other.key &&
        monthId == other.monthId &&
        summary == other.summary;
  }

  @override
  int get hashCode => key.hashCode ^ monthId.hashCode ^ summary.hashCode;
}

/// generated route for
/// [NewFlatScreen]
class NewFlatRoute extends PageRouteInfo<void> {
  const NewFlatRoute({List<PageRouteInfo>? children})
    : super(NewFlatRoute.name, initialChildren: children);

  static const String name = 'NewFlatRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const NewFlatScreen();
    },
  );
}
