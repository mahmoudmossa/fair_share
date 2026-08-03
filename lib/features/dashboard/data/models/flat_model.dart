import '../../domain/entities/flat_entity.dart';

class FlatModel extends FlatEntity {
  const FlatModel({
    required super.id,
    required super.name,
    required super.invitationCode,
    required super.createdBy,
    required super.createdByName,
    super.billingCalculationDay,
  });

  factory FlatModel.fromMap(Map<String, dynamic> map, String id) {
    return FlatModel(
      id: id,
      name: map['name'] as String? ?? '',
      invitationCode: map['invitationCode'] as String? ?? '',
      createdBy: map['createdBy'] as String? ?? '',
      createdByName: map['createdByName'] as String? ?? '',
      billingCalculationDay: (map['billingCalculationDay'] as num?)?.toInt() ?? 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'invitationCode': invitationCode,
      'createdBy': createdBy,
      'createdByName': createdByName,
      'billingCalculationDay': billingCalculationDay,
    };
  }
}
