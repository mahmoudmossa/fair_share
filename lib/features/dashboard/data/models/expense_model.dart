import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/expense_entity.dart';
import '../../domain/entities/recurrence_type.dart';

class ExpenseModel extends ExpenseEntity {
  const ExpenseModel({
    required super.id,
    required super.title,
    required super.amount,
    required super.payerId,
    required super.payerName,
    required super.category,
    required super.date,
    required super.isDisputed,
    super.disputeReason,
    super.recurrence,
    super.specificMonths,
  });

  factory ExpenseModel.fromMap(Map<String, dynamic> map, String id) {
    DateTime parsedDate;
    final dynamic rawDate = map['date'];
    if (rawDate is Timestamp) {
      parsedDate = rawDate.toDate();
    } else if (rawDate is String) {
      parsedDate = DateTime.tryParse(rawDate) ?? DateTime.now();
    } else {
      parsedDate = DateTime.now();
    }

    return ExpenseModel(
      id: id,
      title: map['title'] as String? ?? '',
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      payerId: map['payerId'] as String? ?? '',
      payerName: map['payerName'] as String? ?? '',
      category: map['category'] as String? ?? 'other',
      date: parsedDate,
      isDisputed: map['isDisputed'] as bool? ?? false,
      disputeReason: map['disputeReason'] as String?,
      recurrence: RecurrenceType.fromString(map['recurrence'] as String?),
      specificMonths: (map['specificMonths'] as List<dynamic>?)?.map((e) => e as int).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'amount': amount,
      'payerId': payerId,
      'payerName': payerName,
      'category': category,
      'date': Timestamp.fromDate(date),
      'isDisputed': isDisputed,
      'disputeReason': disputeReason,
      'recurrence': recurrence.toJson(),
      'specificMonths': specificMonths,
    };
  }
}
