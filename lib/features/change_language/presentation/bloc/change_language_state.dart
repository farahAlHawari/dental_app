part of 'change_language_bloc.dart';

@immutable
sealed class ChangeLanguageState {}

final class ChangeLanguageInitial extends ChangeLanguageState {}
final class ChangeLanguageLoading extends ChangeLanguageState {}
final class ChangeLanguageSuccess extends ChangeLanguageState {}
final class ChangeLanguageFailure extends ChangeLanguageState {
  final String errMessage;
  ChangeLanguageFailure({required this.errMessage});
}