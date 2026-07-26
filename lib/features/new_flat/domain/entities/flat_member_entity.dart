import 'package:equatable/equatable.dart';

class FlatMemberEntity extends Equatable {
  final String id;
  final String name;
  final String? userId;
  const FlatMemberEntity({required this.id, required this.name, this.userId});

  @override
  List<Object?> get props => [id, name, userId];
}
