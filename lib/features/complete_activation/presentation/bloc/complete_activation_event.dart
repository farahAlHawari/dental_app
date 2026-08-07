part of 'complete_activation_bloc.dart';

@immutable
sealed class CompleteActivationEvent {}

final class CompleteActivationSubmitted extends CompleteActivationEvent {
  final String temporaryToken;
  final String newPassword;

  CompleteActivationSubmitted({
    required this.temporaryToken,
    required this.newPassword,
  });
}
