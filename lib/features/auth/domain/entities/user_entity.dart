import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String? flatId;

  const UserEntity({
    required this.id,
    required this.email,
    this.flatId,
  });

  UserEntity copyWith({
    String? id,
    String? email,
    String? flatId,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      flatId: flatId ?? this.flatId,
    );
  }

  @override
  List<Object?> get props => [id, email, flatId];
}
