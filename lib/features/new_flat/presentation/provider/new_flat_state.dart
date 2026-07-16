// lib/features/new_flat/presentation/provider/new_flat_state.dart
import 'package:equatable/equatable.dart';

abstract class New_flatState extends Equatable {
  const New_flatState();

  @override
  List<Object?> get props => [];
}

class New_flatInitial extends New_flatState {
  const New_flatInitial();
}

class New_flatLoading extends New_flatState {
  const New_flatLoading();
}

class New_flatSuccess extends New_flatState {
  const New_flatSuccess();
}

class New_flatError extends New_flatState {
  final String message;
  const New_flatError(this.message);

  @override
  List<Object?> get props => [message];
}

class New_flatLoaded extends New_flatState {
  const New_flatLoaded();
}
