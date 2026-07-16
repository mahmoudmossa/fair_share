import 'package:fair_share/core/errors/server_failure_type.dart';
import 'package:firebase_core/firebase_core.dart';

abstract class Failure {
  final ServerFailureType type;
  const Failure(this.type);
}

class ServerFailure extends Failure {
  ServerFailure(super.type);
}

class NetworkFailure extends Failure {
  NetworkFailure(super.type);
}

class FirebaseErrorMapper {
  Failure mapException(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
        return ServerFailure(ServerFailureType.permissionDenied);
      case 'unauthenticated':
        return ServerFailure(ServerFailureType.unauthenticated);
      case 'unavailable':
        return NetworkFailure(ServerFailureType.unavailable);
      default:
        return ServerFailure(ServerFailureType.unknown);
    }
  }
}
