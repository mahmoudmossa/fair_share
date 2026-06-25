class ExpenseEntity {
  final String id;
  final String title;
  final double amount;
  final String payerId;
  final String payerName;
  final String category; // 'electricity' | 'internet' | 'groceries' | 'other'
  final DateTime date;
  final bool isDisputed;
  final String? disputeReason;

  const ExpenseEntity({
    required this.id,
    required this.title,
    required this.amount,
    required this.payerId,
    required this.payerName,
    required this.category,
    required this.date,
    required this.isDisputed,
    this.disputeReason,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpenseEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          amount == other.amount &&
          payerId == other.payerId &&
          payerName == other.payerName &&
          category == other.category &&
          date == other.date &&
          isDisputed == other.isDisputed &&
          disputeReason == other.disputeReason;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      amount.hashCode ^
      payerId.hashCode ^
      payerName.hashCode ^
      category.hashCode ^
      date.hashCode ^
      isDisputed.hashCode ^
      disputeReason.hashCode;
}
