import 'package:freezed_annotation/freezed_annotation.dart';

part 'action_state.freezed.dart';

@freezed
sealed class ActionState<T> with _$ActionState<T> {
  const ActionState._(); // allows defining custom getters/methods

  const factory ActionState.initial() = ActionInitial<T>;
  const factory ActionState.loading() = ActionLoading<T>;
  const factory ActionState.success(T data) = ActionSuccess<T>;
  const factory ActionState.error(Object error, [StackTrace? stackTrace]) = ActionError<T>;

  bool get isLoading => this is ActionLoading<T>;
  bool get isSuccess => this is ActionSuccess<T>;
  bool get isError => this is ActionError<T>;
}
