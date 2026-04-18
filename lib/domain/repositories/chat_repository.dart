import 'package:fpdart/fpdart.dart';

import '../../core/error/failure.dart';
import '../entities/chat.dart';

abstract class ChatRepository {
  Future<Either<Failure, Conversation>> start({
    String? customerName,
    String? customerEmail,
    String language,
  });

  Future<Either<Failure, ChatMessage>> send({
    required int conversationId,
    required String content,
    String? englishContent,
    String? senderName,
  });

  Future<Either<Failure, List<ChatMessage>>> messages({
    required int conversationId,
    DateTime? since,
  });
}
