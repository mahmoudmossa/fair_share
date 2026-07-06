import 'package:fair_share/core/errors/failures.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'action_state.freezed.dart';

@freezed
sealed class ActionState with _$ActionState {
  const factory ActionState.initial() = _InitialState;
  const factory ActionState.loading() = _LoadingState;
  const factory ActionState.success() = _SuccessState;
  const factory ActionState.failure(Failure failure) = _FailureState;
}
