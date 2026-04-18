import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/error/failure.dart';
import '../../core/network/api_client.dart';
import '../../data/datasources/remote/chat_api.dart';
import '../../data/repositories/chat_repository_impl.dart';
import '../../domain/entities/chat.dart';
import '../../domain/repositories/chat_repository.dart';

final chatApiProvider = Provider<ChatApi>((ref) {
  return ChatApi(ref.watch(dioProvider));
});

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepositoryImpl(ref.watch(chatApiProvider));
});

/// Live chat state for the currently-open support conversation.
///
/// The controller is created once the user opens the Contact Us / Live chat
/// screen; it creates (or resumes) a conversation on the server, then polls
/// for new messages every few seconds using the `since=` query param so we
/// don't re-download the whole thread.
class ChatState {
  const ChatState({
    this.conversation,
    this.messages = const [],
    this.loading = false,
    this.sending = false,
    this.error,
  });

  final Conversation? conversation;
  final List<ChatMessage> messages;
  final bool loading;
  final bool sending;
  final String? error;

  bool get isReady => conversation != null;

  ChatState copyWith({
    Conversation? conversation,
    List<ChatMessage>? messages,
    bool? loading,
    bool? sending,
    Object? error = _unset,
  }) =>
      ChatState(
        conversation: conversation ?? this.conversation,
        messages: messages ?? this.messages,
        loading: loading ?? this.loading,
        sending: sending ?? this.sending,
        error: identical(error, _unset) ? this.error : error as String?,
      );
}

const Object _unset = Object();

class ChatController extends StateNotifier<ChatState> {
  ChatController(this._repo) : super(const ChatState());

  final ChatRepository _repo;
  Timer? _poll;

  Future<void> open({
    String? customerName,
    String? customerEmail,
    String language = 'en',
  }) async {
    if (state.isReady) return;
    state = state.copyWith(loading: true, error: null);
    final result = await _repo.start(
      customerName: customerName,
      customerEmail: customerEmail,
      language: language,
    );
    state = result.match(
      (f) => state.copyWith(loading: false, error: f.message),
      (c) => state.copyWith(
        loading: false,
        conversation: c,
        messages: const [],
      ),
    );
    if (state.isReady) {
      await _fetch();
      _startPolling();
    }
  }

  Future<void> send(String content, {String? senderName}) async {
    final convo = state.conversation;
    if (convo == null || content.trim().isEmpty) return;
    state = state.copyWith(sending: true, error: null);
    final optimistic = ChatMessage(
      id: -DateTime.now().millisecondsSinceEpoch,
      conversationId: convo.id,
      sender: 'customer',
      senderName: senderName,
      content: content,
      createdAt: DateTime.now(),
    );
    state = state.copyWith(messages: [...state.messages, optimistic]);

    final result = await _repo.send(
      conversationId: convo.id,
      content: content,
      senderName: senderName,
    );
    state = result.match(
      (f) => state.copyWith(
        sending: false,
        error: f.message,
        messages: state.messages.where((m) => m.id != optimistic.id).toList(),
      ),
      (saved) {
        final replaced = [
          for (final m in state.messages)
            if (m.id == optimistic.id) saved else m,
        ];
        return state.copyWith(sending: false, messages: replaced);
      },
    );
    await _fetch();
  }

  Future<void> refresh() => _fetch();

  void _startPolling() {
    _poll?.cancel();
    _poll = Timer.periodic(const Duration(seconds: 5), (_) => _fetch());
  }

  Future<void> _fetch() async {
    final convo = state.conversation;
    if (convo == null) return;
    final since = state.messages.isEmpty
        ? null
        : state.messages
            .map((m) => m.createdAt)
            .whereType<DateTime>()
            .fold<DateTime?>(
              null,
              (prev, next) => prev == null || next.isAfter(prev) ? next : prev,
            );
    final result = await _repo.messages(
      conversationId: convo.id,
      since: since,
    );
    result.match(
      (f) {
        if (f is! NetworkFailure) {
          state = state.copyWith(error: f.message);
        }
      },
      (fresh) {
        if (fresh.isEmpty) return;
        final existingIds = state.messages.map((m) => m.id).toSet();
        final merged = [
          ...state.messages,
          ...fresh.where((m) => !existingIds.contains(m.id)),
        ]..sort((a, b) =>
            (a.createdAt ?? DateTime(0)).compareTo(b.createdAt ?? DateTime(0)));
        state = state.copyWith(messages: merged);
      },
    );
  }

  @override
  void dispose() {
    _poll?.cancel();
    super.dispose();
  }
}

final chatControllerProvider =
    StateNotifierProvider.autoDispose<ChatController, ChatState>((ref) {
  final ctrl = ChatController(ref.watch(chatRepositoryProvider));
  ref.onDispose(ctrl.dispose);
  return ctrl;
});
