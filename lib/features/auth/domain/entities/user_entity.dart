class UserEntity {
  final String id;
  final String email;
  final String? displayName;
  final String? flatId;

  const UserEntity({
    required this.id,
    required this.email,
    this.displayName,
    this.flatId,
  });

  UserEntity copyWith({
    String? id,
    String? email,
    String? displayName,
    String? flatId,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
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
          displayName == other.displayName &&
          flatId == other.flatId;

  @override
  int get hashCode =>
      id.hashCode ^ email.hashCode ^ displayName.hashCode ^ flatId.hashCode;
}

