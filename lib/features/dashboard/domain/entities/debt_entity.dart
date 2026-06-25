class DebtEntity {
  final String id;
  final String fromId;
  final String fromName;
  final String toId;
  final String toName;
  final double amount;
  final bool isSettled;

  const DebtEntity({
    required this.id,
    required this.fromId,
    required this.fromName,
    required this.toId,
    required this.toName,
    required this.amount,
    required this.isSettled,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DebtEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          fromId == other.fromId &&
          fromName == other.fromName &&
          toId == other.toId &&
          toName == other.toName &&
          amount == other.amount &&
          isSettled == other.isSettled;

  @override
  int get hashCode =>
      id.hashCode ^
      fromId.hashCode ^
      fromName.hashCode ^
      toId.hashCode ^
      toName.hashCode ^
      amount.hashCode ^
      isSettled.hashCode;
}
