import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fair_share/core/providers/firebase_providers.dart';
import 'package:fair_share/core/constants/firestore_constants.dart';
import 'package:fair_share/features/new_flat/data/data_sources/remote/flat_remote_data_source.dart';
import 'package:fair_share/features/new_flat/data/models/flat_dto.dart';
import 'package:fair_share/features/new_flat/data/models/flat_member_dto.dart';
import 'package:fair_share/features/new_flat/data/models/flat_cost_dto.dart';

part 'flat_remote_data_source_impl.g.dart';

@riverpod
FlatRemoteDataSource flatRemoteDataSource(Ref ref) {
  return FlatRemoteDataSourceImpl(ref.watch(firebaseFirestoreProvider));
}

class FlatRemoteDataSourceImpl implements FlatRemoteDataSource {
  final FirebaseFirestore _firestore;

  FlatRemoteDataSourceImpl(this._firestore);

  String _getMonthId(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}";
  }

  String _getMonthNameFormatted(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return "${months[date.month - 1]} ${date.year}";
  }

  @override
  Future<void> createFlat({
    required FlatDto flat,
    required List<FlatMemberDto> members,
    required List<FlatCostDto> costs,
  }) async {
    final batch = _firestore.batch();

    // 1. Write the main flat document under `/wgs/{flatId}`
    final flatRef = _firestore.collection(FirestoreConstants.wgs).doc(flat.id);
    batch.set(flatRef, flat.toJson());

    // 2. Write all setup members
    for (final member in members) {
      final docId = member.id;
      final memberRef = flatRef
          .collection(FirestoreConstants.members)
          .doc(docId);
      batch.set(memberRef, member.toJson());
    }

    // 3. Write all setup initial expenses/costs
    for (final cost in costs) {
      final costRef = flatRef.collection(FirestoreConstants.expenses).doc();
      final costJson = {
        ...cost.toJson(),
        'id': costRef.id,
      };
      batch.set(costRef, costJson);
    }

    // Initialize the billing cycle doc in the database for the current month
    final now = DateTime.now();
    final currentMonthId = _getMonthId(now);
    final totalSetupCosts = costs.fold(0.0, (total, cost) => total + cost.amount);

    final cycleRef = flatRef
        .collection(FirestoreConstants.billingCycles)
        .doc(currentMonthId);
    batch.set(cycleRef, {
      'monthName': _getMonthNameFormatted(now),
      'status': 'draft',
      'totalCosts': totalSetupCosts,
      'settledPercentage': 85.0,
    });

    // 4. Update User profile to set flatId
    final userRef = _firestore
        .collection(FirestoreConstants.users)
        .doc(flat.createdBy);
    batch.update(userRef, {FirestoreConstants.flatId: flat.id});

    // Commit batch transaction
    await batch.commit();
  }

  @override
  Future<void> deleteFlat(String flatId) {
    throw UnimplementedError();
  }

  @override
  Future<List<FlatDto>> getAllFlats() {
    throw UnimplementedError();
  }

  @override
  Future<FlatDto> getFlat(String flatId) {
    throw UnimplementedError();
  }

  @override
  Future<void> updateFlat(FlatDto flatEntity) {
    throw UnimplementedError();
  }
}
