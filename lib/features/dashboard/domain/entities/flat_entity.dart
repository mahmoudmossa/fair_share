class FlatEntity {
  final String id;
  final String name;
  final String invitationCode;
  final String createdBy;
  final String createdByName;

  const FlatEntity({
    required this.id,
    required this.name,
    required this.invitationCode,
    required this.createdBy,
    required this.createdByName,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FlatEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          invitationCode == other.invitationCode &&
          createdBy == other.createdBy &&
          createdByName == other.createdByName;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      invitationCode.hashCode ^
      createdBy.hashCode ^
      createdByName.hashCode;
}
