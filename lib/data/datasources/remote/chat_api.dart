import 'package:dio/dio.dart';

/// Customer-facing endpoints for live chat (客服聊天).
///   POST /v1/h5/conversations
///   POST /v1/h5/conversations/{id}/messages
///   GET  /v1/h5/conversations/{id}/messages?since=ISO8601
///
/// All three require `auth:h5`.
class ChatApi {
  ChatApi(this._dio);
  final Dio _dio;

  static const String _prefix = '/v1/h5';

  Future<Response<Map<String, dynamic>>> startConversation({
    String? customerName,
    String? customerEmail,
    String language = 'en',
  }) =>
      _dio.post<Map<String, dynamic>>(
        '$_prefix/conversations',
        data: {
          if (customerName != null) 'customer_name': customerName,
          if (customerEmail != null) 'customer_email': customerEmail,
          'language': language,
        },
      );

  Future<Response<Map<String, dynamic>>> sendMessage({
    required int conversationId,
    required String content,
    String? englishContent,
    String? senderName,
  }) =>
      _dio.post<Map<String, dynamic>>(
        '$_prefix/conversations/$conversationId/messages',
        data: {
          'content': content,
          if (englishContent != null) 'english_content': englishContent,
          if (senderName != null) 'sender_name': senderName,
        },
      );

  Future<Response<Map<String, dynamic>>> fetchMessages({
    required int conversationId,
    DateTime? since,
  }) =>
      _dio.get<Map<String, dynamic>>(
        '$_prefix/conversations/$conversationId/messages',
        queryParameters: {
          if (since != null) 'since': since.toUtc().toIso8601String(),
        },
      );
}
