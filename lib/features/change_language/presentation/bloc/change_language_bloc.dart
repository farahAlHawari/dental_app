import 'package:bloc/bloc.dart';
import 'package:dental_app/features/change_language/domain/repositories/change_language_repository_impl.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:dental_app/core/api/dio_consumer.dart';
import '../../data/datasources/change_language_data_source.dart';

part 'change_language_event.dart';
part 'change_language_state.dart';

class ChangeLanguageBloc extends Bloc<ChangeLanguageEvent, ChangeLanguageState> {
  final _repository = ChangeLanguageRepositoryImpl(
    dataSource: ChangeLanguageDataSource(api: DioConsumer(dio: Dio())),
  );

  ChangeLanguageBloc() : super(ChangeLanguageInitial()) {
    on<ChangeLanguageSubmitted>((event, emit) async {
      emit(ChangeLanguageLoading());
      final result = await _repository.updateLanguage(
        language: event.language,
      );
      result.fold(
        (failure) => emit(ChangeLanguageFailure(errMessage: failure.errMessage)),
        (_) => emit(ChangeLanguageSuccess()),
      );
    });
  }
}