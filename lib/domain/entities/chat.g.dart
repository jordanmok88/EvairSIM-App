// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConversationImpl _$$ConversationImplFromJson(Map<String, dynamic> json) =>
    _$ConversationImpl(
      id: (json['id'] as num).toInt(),
      customerName: json['customer_name'] as String?,
      customerEmail: json['customer_email'] as String?,
      language: json['language'] as String? ?? 'en',
      status: json['status'] as String? ?? 'open',
      lastMessage: json['last_message'] as String?,
      lastSender: json['last_sender'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$ConversationImplToJson(_$ConversationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'customer_name': instance.customerName,
      'customer_email': instance.customerEmail,
      'language': instance.language,
      'status': instance.status,
      'last_message': instance.lastMessage,
      'last_sender': instance.lastSender,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

_$ChatMessageImpl _$$ChatMessageImplFromJson(Map<String, dynamic> json) =>
    _$ChatMessageImpl(
      id: (json['id'] as num).toInt(),
      conversationId: (json['conversation_id'] as num?)?.toInt(),
      sender: json['sender'] as String,
      senderName: json['sender_name'] as String?,
      content: json['content'] as String? ?? '',
      englishContent: json['english_content'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$ChatMessageImplToJson(_$ChatMessageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'conversation_id': instance.conversationId,
      'sender': instance.sender,
      'sender_name': instance.senderName,
      'content': instance.content,
      'english_content': instance.englishContent,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
