part of 'change_phone_bloc.dart';

@immutable
sealed class ChangePhoneEvent {}

final class ChangePhoneSubmitted extends ChangePhoneEvent {
  final String newPhone;
  ChangePhoneSubmitted({required this.newPhone});
}
