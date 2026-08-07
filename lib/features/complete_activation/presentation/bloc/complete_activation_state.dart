part of 'complete_activation_bloc.dart';

@immutable
sealed class CompleteActivationState {}

final class CompleteActivationInitial extends CompleteActivationState {}

final class CompleteActivationLoading extends CompleteActivationState {}

final class CompleteActivationSuccess extends CompleteActivationState {}

final class CompleteActivationFailure extends CompleteActivationState {
  final String errMessage;
  CompleteActivationFailure({required this.errMessage});
}
