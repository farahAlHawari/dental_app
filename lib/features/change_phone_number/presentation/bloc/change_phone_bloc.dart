import 'package:bloc/bloc.dart';
import 'package:dental_app/core/api/dio_consumer.dart';
import 'package:dental_app/features/change_phone_number/data/datasources/change_phone_data_source.dart';
import 'package:dental_app/features/change_phone_number/domain/repositories/change_phone_repository_impl.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

part 'change_phone_event.dart';
part 'change_phone_state.dart';

class ChangePhoneBloc extends Bloc<ChangePhoneEvent, ChangePhoneState> {
  final _repository = ChangePhoneRepositoryImpl(
    dataSource: ChangePhoneDataSource(api: DioConsumer(dio: Dio())),
  );

  ChangePhoneBloc() : super(ChangePhoneInitial()) {
    on<ChangePhoneSubmitted>((event, emit) async {
      emit(ChangePhoneLoading());
      final result = await _repository.startChangePhone(
        newPhone: event.newPhone,
      );
      result.fold(
        (failure) => emit(ChangePhoneFailure(errMessage: failure.errMessage)),
        (_) => emit(ChangePhoneSuccess(newPhone: event.newPhone)),
      );
    });
  }
}
