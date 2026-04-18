import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat.freezed.dart';
part 'chat.g.dart';

/// A single chat exchange between the customer and the support team,
/// mirrors `App\Models\Conversation` on the backend.
@freezed
class Conversation with _$Conversation {
  const factory Conversation({
    required int id,
    @JsonKey(name: 'customer_name') String? customerName,
    @JsonKey(name: 'customer_email') String? customerEmail,
    @Default('en') String language,

    /// `open` | `needs_agent` | `resolved`.
    @Default('open') String status,

    @JsonKey(name: 'last_message') String? lastMessage,
    @JsonKey(name: 'last_sender') String? lastSender,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _Conversation;

  factory Conversation.fromJson(Map<String, dynamic> json) =>
      _$ConversationFromJson(json);
}

/// A single chat message. `sender` is one of `customer`, `agent`, or `ai`.
@freezed
class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required int id,
    @JsonKey(name: 'conversation_id') int? conversationId,
    required String sender,
    @JsonKey(name: 'sender_name') String? senderName,
    @Default('') String content,
    @JsonKey(name: 'english_content') String? englishContent,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);

  const ChatMessage._();

  bool get isCustomer => sender.toLowerCase() == 'customer';
  bool get isAgent => sender.toLowerCase() == 'agent';
  bool get isAi => sender.toLowerCase() == 'ai';
}
