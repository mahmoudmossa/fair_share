import 'package:easy_localization/easy_localization.dart';
import 'package:fair_share/core/localization/locale_keys.g.dart';

enum ServerFailureType {
  permissionDenied,
  unauthenticated,
  unavailable,
  unknown,
  alreadyClaimed,
  invalidInvite,
}

extension ServerFailureTypeX on ServerFailureType {
  String get localizedMessage {
    switch (this) {
      case ServerFailureType.permissionDenied:
        return LocaleKeys.errors_permission_denied.tr();
      case ServerFailureType.unauthenticated:
        return LocaleKeys.errors_unauthenticated.tr();
      case ServerFailureType.unavailable:
        return LocaleKeys.errors_unavailable.tr();
      case ServerFailureType.unknown:
        return LocaleKeys.errors_unknown.tr();
      case ServerFailureType.alreadyClaimed:
        return LocaleKeys.errors_already_claimed.tr();
      case ServerFailureType.invalidInvite:
        return LocaleKeys.errors_invalid_invite.tr();
    }
  }
}

