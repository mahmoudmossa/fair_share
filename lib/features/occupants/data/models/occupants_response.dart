import 'package:fair_share/features/occupants/domain/entities/occupant.dart';
import 'package:json_annotation/json_annotation.dart';
part 'occupants_response.g.dart';

@JsonSerializable()
class OccupantResponse {
  final String id;
  final String name;

  OccupantResponse(this.id, this.name);

  factory OccupantResponse.fromJson(Map<String, dynamic> json) =>
      _$OccupantResponseFromJson(json);
  Map<String, dynamic> toJson() => _$OccupantResponseToJson(this);

  Occupant toEntity() => Occupant(id: id, name: name);
}
