import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fair_share/core/providers/firebase_providers.dart';
import 'package:fair_share/features/new_flat/data/data_sources/remote/flat_remote_data_source.dart';
import 'package:fair_share/features/new_flat/data/models/flat_dto.dart';
import 'package:fair_share/features/new_flat/domain/entities/flat_entity.dart';

part 'flat_remote_data_source_impl.g.dart';

@riverpod
FlatRemoteDataSource flatRemoteDataSource(Ref ref) {
  return FlatRemoteDataSourceImpl(ref.watch(firebaseFirestoreProvider));
}

class FlatRemoteDataSourceImpl implements FlatRemoteDataSource {
  final FirebaseFirestore _firestore;

  FlatRemoteDataSourceImpl(this._firestore);

  @override
  Future<void> createFlat(FlatDto flat) async {
    // Approach A: No local try/catch. Let raw exceptions bubble up to the Repository.
    await _firestore.collection('flats').doc(flat.id).set(flat.toJson());
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
    // TODO: implement getFlat
    throw UnimplementedError();
  }

  @override
  Future<void> updateFlat(FlatDto flatEntity) {
    // TODO: implement updateFlat
    throw UnimplementedError();
  }
}
