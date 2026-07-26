import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/expense_entity.dart';
import '../../../new_flat/domain/entities/recurrence_type.dart';

part 'expense_model.g.dart';

DateTime _dateFromJson(dynamic json) {
  if (json is Timestamp) {
    return json.toDate();
  } else if (json is String) {
    return DateTime.tryParse(json) ?? DateTime.now();
  }
  return DateTime.now();
}

dynamic _dateToJson(DateTime date) => Timestamp.fromDate(date);

@JsonSerializable()
class ExpenseModel {
  final String id;
  final String title;
  final double amount;
  final String payerId;
  final String payerName;

  @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)
  final DateTime date;

  final bool isDisputed;
  final String? disputeReason;

  @JsonKey(unknownEnumValue: RecurrenceType.oneTime)
  final RecurrenceType recurrence;

  final List<int>? specificMonths;

  const ExpenseModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.payerId,
    required this.payerName,
    required this.date,
    required this.isDisputed,
    this.disputeReason,
    this.recurrence = RecurrenceType.oneTime,
    this.specificMonths,
  });

  factory ExpenseModel.fromEntity(ExpenseEntity entity) {
    return ExpenseModel(
      id: entity.id,
      title: entity.title,
      amount: entity.amount,
      payerId: entity.payerId,
      payerName: entity.payerName,
      date: entity.date,
      isDisputed: entity.isDisputed,
      disputeReason: entity.disputeReason,
      recurrence: entity.recurrence,
      specificMonths: entity.specificMonths,
    );
  }

  ExpenseEntity toEntity() {
    return ExpenseEntity(
      id: id,
      title: title,
      amount: amount,
      payerId: payerId,
      payerName: payerName,
      date: date,
      isDisputed: isDisputed,
      disputeReason: disputeReason,
      recurrence: recurrence,
      specificMonths: specificMonths,
    );
  }

  factory ExpenseModel.fromJson(Map<String, dynamic> json) =>
      _$ExpenseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExpenseModelToJson(this);

  factory ExpenseModel.fromMap(Map<String, dynamic> map, String id) {
    return ExpenseModel.fromJson({'id': id, ...map});
  }

  Map<String, dynamic> toMap() => toJson();
}
