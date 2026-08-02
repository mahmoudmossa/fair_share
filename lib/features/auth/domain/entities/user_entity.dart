class UserEntity {
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
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email &&
          flatId == other.flatId;

  @override
  int get hashCode => id.hashCode ^ email.hashCode ^ flatId.hashCode;
}
