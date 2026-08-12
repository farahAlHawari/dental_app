import 'package:dartz/dartz.dart';
import 'package:dental_app/core/errors/expentions.dart';
import 'package:dental_app/core/errors/failure.dart';
import 'package:dental_app/features/chatbot/data/datasources/chatbot_remote_data_source.dart';
import 'package:dental_app/features/chatbot/data/models/chatbot_api_mode.dart';
import 'package:dental_app/features/chatbot/data/models/chatbot_message_response.dart';
import 'package:dental_app/features/chatbot/data/models/chatbot_summary_response.dart';
import 'package:dental_app/features/chatbot/domain/repositories/chatbot_repository.dart';

class ChatbotRepositoryImpl implements ChatbotRepository {
  final ChatbotRemoteDataSource remoteDataSource;

  ChatbotRepositoryImpl({required this.remoteDataSource});

  Failure _map(ServerException e) => Failure(
        errMessage: e.errorModel.errorMessage,
        code: e.errorModel.code,
        statusCode: e.errorModel.statusCode,
      );

  @override
  Future<Either<Failure, ChatbotMessageResponse>> sendMessage({
    required ChatbotApiMode mode,
    required String message,
    required int turnCount,
    String? previousInteractionId,
  }) async {
    try {
      final result = await remoteDataSource.sendMessage(
        mode: mode,
        message: message,
        turnCount: turnCount,
        previousInteractionId: previousInteractionId,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(_map(e));
    } catch (e) {
      return Left(Failure(errMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ChatbotSummaryResponse>> summarize({
    required String previousInteractionId,
  }) async {
    try {
      final result = await remoteDataSource.summarize(
        previousInteractionId: previousInteractionId,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(_map(e));
    } catch (e) {
      return Left(Failure(errMessage: e.toString()));
    }
  }
}
