class Occupant {
  final String id;
  final String name;
  final String? avatarUrl;
  final String? userId;
  final String? invitationCode;

  Occupant({
    required this.id,
    required this.name,
    this.avatarUrl,
    this.userId,
    this.invitationCode,
  });

  Occupant copyWith({
    String? id,
    String? name,
    String? avatarUrl,
    String? userId,
    String? invitationCode,
  }) {
    return Occupant(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      userId: userId ?? this.userId,
      invitationCode: invitationCode ?? this.invitationCode,
    );
  }
}

