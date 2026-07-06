import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fair_share/core/providers/firebase_providers.dart';
import 'package:fair_share/features/occupants/data/repositories/occupants_repository_impl.dart';
import 'package:fair_share/features/occupants/data/sources/occupants_data_source_impl.dart';
import 'package:fair_share/features/occupants/domain/repositories/occupants_repository.dart';
import 'package:fair_share/features/occupants/presentation/providers/occupants_data_source_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'occupants_repository_provider.g.dart';

@riverpod
OccupantsRepository occupantsRepository(Ref ref) {
  final occpantsDataSource = ref.watch(occupantsDataSourceProvider);
  final repo = OccupantsRepositoryImpl(occpantsDataSource);
  return repo;
}
