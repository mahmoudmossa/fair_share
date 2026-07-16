import 'package:equatable/equatable.dart';

class FlatMemberEntity extends Equatable {
  final String name;
  const FlatMemberEntity({required this.name});
  @override
  List<Object?> get props => [name];
}
