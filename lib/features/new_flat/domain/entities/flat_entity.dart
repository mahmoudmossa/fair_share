import 'package:equatable/equatable.dart';

class FlatEntity extends Equatable {
  final String id;
  final String name;
  const FlatEntity({required this.id, required this.name});
  @override
  List<Object?> get props => [id, name];
}
