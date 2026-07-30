part of 'change_language_bloc.dart';

@immutable
sealed class ChangeLanguageEvent {}

final class ChangeLanguageSubmitted extends ChangeLanguageEvent {
  final String language;
  ChangeLanguageSubmitted({required this.language});
}