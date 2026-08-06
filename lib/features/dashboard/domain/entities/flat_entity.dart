import 'package:equatable/equatable.dart';

class FlatEntity extends Equatable {
  final String id;
  final String name;
  final String invitationCode;
  final String createdBy;
  final String createdByName;
  final int billingCalculationDay;

  const FlatEntity({
    required this.id,
    required this.name,
    required this.invitationCode,
    required this.createdBy,
    required this.createdByName,
    this.billingCalculationDay = 1,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        invitationCode,
        createdBy,
        createdByName,
        billingCalculationDay,
      ];
}

