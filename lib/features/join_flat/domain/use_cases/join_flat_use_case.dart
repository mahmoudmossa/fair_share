import 'package:fair_share/core/errors/failures.dart';
import 'package:fair_share/core/errors/server_failure_type.dart';
import '../repositories/join_flat_repository.dart';

class JoinFlatUseCase {
  final JoinFlatRepository repository;

  JoinFlatUseCase(this.repository);

  Future<void> call({
    required String inviteCode,
    required String userId,
    required String userEmail,
  }) async {
    final cleanCode = inviteCode.trim().toUpperCase();
    
    if (cleanCode.length != 6) {
      throw ServerFailure(ServerFailureType.unknown);
    }

    await repository.joinFlatWithCode(
      inviteCode: cleanCode,
      userId: userId,
      userEmail: userEmail,
    );
  }
}
