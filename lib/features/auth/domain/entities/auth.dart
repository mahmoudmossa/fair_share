import 'package:equatable/equatable.dart';

class Auth extends Equatable {
  final String? data;

  const Auth({
    required this.data,
  });

  @override
  List<Object?> get props => [data];
}
