import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fair_share/core/providers/firebase_providers.dart';
import 'package:fair_share/features/occupants/data/sources/occupants_data_source_impl.dart';
import 'package:fair_share/features/occupants/data/sources/ouccpants_data_source.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'occupants_data_source_provider.g.dart';

@riverpod
OuccpantsDataSource occupantsDataSource(Ref ref) {
  final FirebaseFirestore firestore = ref.watch(firebaseFirestoreProvider);
  final dataSource = OccupantsDataSourceImp(firestore);
  return dataSource;
}
