import 'package:equatable/equatable.dart';

class FlatMemberDto extends Equatable {
  final String name;
  const FlatMemberDto({required this.name});
  @override
  List<Object?> get props => [name];
}
