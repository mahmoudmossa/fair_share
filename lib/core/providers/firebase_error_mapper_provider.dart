import 'package:fair_share/core/errors/failures.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_error_mapper_provider.g.dart';

@riverpod
FirebaseErrorMapper firebaseErrorMapper(Ref ref) {
  return FirebaseErrorMapper();
}
