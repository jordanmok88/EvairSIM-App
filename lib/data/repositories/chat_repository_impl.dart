import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../../core/error/exceptions.dart';
import '../../core/error/failure.dart';
import '../../core/network/response_envelope.dart';
import '../../domain/entities/chat.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/remote/chat_api.dart';

class ChatRepositoryImpl implements ChatRepository {
  ChatRepositoryImpl(this._api);
  final ChatApi _api;

  @override
  Future<Either<Failure, Conversation>> start({
    String? customerName,
    String? customerEmail,
    String language = 'en',
  }) =>
      _guard(() async {
        final resp = await _api.startConversation(
          customerName: customerName,
          customerEmail: customerEmail,
          language: language,
        );
        ResponseEnvelope.throwIfError(resp);
        return Conversation.fromJson(ResponseEnvelope.dataMap(resp));
      });

  @override
  Future<Either<Failure, ChatMessage>> send({
    required int conversationId,
    required String content,
    String? englishContent,
    String? senderName,
  }) =>
      _guard(() async {
        final resp = await _api.sendMessage(
          conversationId: conversationId,
          content: content,
          englishContent: englishContent,
          senderName: senderName,
        );
        ResponseEnvelope.throwIfError(resp);
        return ChatMessage.fromJson(ResponseEnvelope.dataMap(resp));
      });

  @override
  Future<Either<Failure, List<ChatMessage>>> messages({
    required int conversationId,
    DateTime? since,
  }) =>
      _guard(() async {
        final resp = await _api.fetchMessages(
          conversationId: conversationId,
          since: since,
        );
        ResponseEnvelope.throwIfError(resp);
        return ResponseEnvelope.dataList(resp)
            .whereType<Map>()
            .map((m) => ChatMessage.fromJson(Map<String, dynamic>.from(m)))
            .toList(growable: false);
      });

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() body) async {
    try {
      return Right(await body());
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } on DioException catch (e) {
      return Left(NetworkFailure(e.message ?? 'Network error'));
    } on FormatException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
