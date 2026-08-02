import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fair_share/core/errors/failures.dart';
import 'package:fair_share/core/errors/server_failure_type.dart';
import 'package:shared_core/shared_core.dart';
import '../../domain/repositories/join_flat_repository.dart';
import '../data_sources/remote/join_flat_remote_data_source.dart';

class JoinFlatRepositoryImpl implements JoinFlatRepository {
  final JoinFlatRemoteDataSource remoteDataSource;
  final AppErrorHandler errorHandler;
  final FirebaseErrorMapper errorMapper;

  JoinFlatRepositoryImpl({
    required this.remoteDataSource,
    required this.errorHandler,
    required this.errorMapper,
  });

  @override
  Future<void> joinFlatWithCode({
    required String inviteCode,
    required String userId,
    required String userEmail,
  }) async {
    try {
      final invitation = await remoteDataSource.findInvitationByCode(inviteCode);
      
      if (invitation.status != 'pending') {
        throw ServerFailure(ServerFailureType.alreadyClaimed);
      }

      await remoteDataSource.executeJoinFlatTransaction(
        inviteCode: inviteCode,
        flatId: invitation.flatId,
        memberId: invitation.memberId,
        userId: userId,
        userEmail: userEmail,
        userName: invitation.memberName,
      );
    } on Failure {
      rethrow;
    } on FirebaseException catch (e, stackTrace) {
      errorHandler.handle(
        e,
        stackTrace,
        context: 'JoinFlatRepositoryImpl.joinFlatWithCode',
      );
      if (e.code == 'not-found') {
        throw ServerFailure(ServerFailureType.invalidInvite);
      }
      throw errorMapper.mapException(e);
    } catch (e, stackTrace) {
      errorHandler.handle(
        e,
        stackTrace,
        context: 'JoinFlatRepositoryImpl.joinFlatWithCode',
      );
      throw ServerFailure(ServerFailureType.unknown);
    }
  }
}
