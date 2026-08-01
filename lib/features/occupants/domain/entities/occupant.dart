class Occupant {
  final String id;
  final String name;
  final String? avatarUrl;

  Occupant({
    required this.id,
    required this.name,
    this.avatarUrl,
  });

  Occupant copyWith({
    String? id,
    String? name,
    String? avatarUrl,
  }) {
    return Occupant(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}

