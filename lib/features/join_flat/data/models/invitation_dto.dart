import 'package:json_annotation/json_annotation.dart';

part 'invitation_dto.g.dart';

@JsonSerializable()
class InvitationDto {
  final String inviteCode;
  final String flatId;
  final String memberId;
  final String memberName;
  final String status;

  const InvitationDto({
    required this.inviteCode,
    required this.flatId,
    required this.memberId,
    required this.memberName,
    required this.status,
  });

  factory InvitationDto.fromJson(Map<String, dynamic> json) =>
      _$InvitationDtoFromJson(json);

  Map<String, dynamic> toJson() => _$InvitationDtoToJson(this);
}
