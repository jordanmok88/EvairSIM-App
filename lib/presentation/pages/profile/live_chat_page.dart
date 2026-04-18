import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../domain/entities/chat.dart';
import '../../providers/auth_providers.dart';
import '../../providers/chat_provider.dart';
import '../../providers/locale_provider.dart';

/// Live chat with the support team, backed by the admin portal's
/// `/v1/h5/conversations` endpoints.
///
/// On open we call `chatController.open(...)` once, which either creates
/// a new conversation or resumes the latest open one for the logged-in
/// user. The controller then polls `/messages?since=…` every five seconds
/// so new agent replies appear without any refresh.
class LiveChatPage extends ConsumerStatefulWidget {
  const LiveChatPage({super.key});

  @override
  ConsumerState<LiveChatPage> createState() => _LiveChatPageState();
}

class _LiveChatPageState extends ConsumerState<LiveChatPage> {
  final _input = TextEditingController();
  final _scroll = ScrollController();
  bool _initialOpen = false;

  @override
  void initState() {
    super.initState();
    // Defer so Riverpod has a frame to wire up the controller.
    WidgetsBinding.instance.addPostFrameCallback((_) => _boot());
  }

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _boot() async {
    if (_initialOpen) return;
    _initialOpen = true;
    final user = ref.read(authControllerProvider).user;
    final locale = ref.read(localeControllerProvider);
    await ref.read(chatControllerProvider.notifier).open(
          customerName: user?.name ?? user?.email,
          customerEmail: user?.email,
          language: locale.locale.languageCode,
        );
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _send() async {
    final text = _input.text.trim();
    if (text.isEmpty) return;
    final user = ref.read(authControllerProvider).user;
    _input.clear();
    HapticFeedback.selectionClick();
    await ref.read(chatControllerProvider.notifier).send(
          text,
          senderName: user?.name ?? user?.email,
        );
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(chatControllerProvider);
    ref.listen(chatControllerProvider, (prev, next) {
      if ((prev?.messages.length ?? 0) != next.messages.length) {
        _scrollToBottom();
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Live chat'),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'Refresh',
            icon: const Icon(Icons.refresh, color: AppColors.textPrimary),
            onPressed: state.isReady
                ? () => ref.read(chatControllerProvider.notifier).refresh()
                : null,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _StatusBanner(state: state),
            Expanded(child: _MessageList(state: state, scroll: _scroll)),
            if (state.error != null) _ErrorBar(message: state.error!),
            _Composer(
              controller: _input,
              onSend: _send,
              disabled: !state.isReady || state.sending,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBanner extends StatelessWidget {
  const _StatusBanner({required this.state});
  final ChatState state;

  @override
  Widget build(BuildContext context) {
    if (state.loading && !state.isReady) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 14,
              height: 14,
              child:
                  CircularProgressIndicator(strokeWidth: 2, color: AppColors.brandOrange),
            ),
            SizedBox(width: 8),
            Text(
              'Connecting to support…',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }
    if (!state.isReady) return const SizedBox.shrink();

    final status = (state.conversation?.status ?? 'open').toLowerCase();
    final (label, color, bg) = switch (status) {
      'resolved' => ('Resolved', const Color(0xFF059669), const Color(0xFFECFDF5)),
      'needs_agent' =>
        ('Agent on the way', AppColors.brandOrange, const Color(0xFFFFF7ED)),
      _ => ('Agents online', const Color(0xFF2563EB), const Color(0xFFEFF6FF)),
    };

    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppSpacing.pageHorizontal,
        AppSpacing.sm,
        AppSpacing.pageHorizontal,
        0,
      ),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageList extends StatelessWidget {
  const _MessageList({required this.state, required this.scroll});
  final ChatState state;
  final ScrollController scroll;

  @override
  Widget build(BuildContext context) {
    if (!state.isReady && state.loading) {
      return const SizedBox.shrink();
    }
    if (state.messages.isEmpty) {
      return const _EmptyHint();
    }
    return ListView.separated(
      controller: scroll,
      padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
      itemCount: state.messages.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, i) => _MessageBubble(message: state.messages[i]),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});
  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final mine = message.isCustomer;
    final bg = mine
        ? AppColors.brandOrange
        : message.isAi
            ? const Color(0xFFF3E8FF)
            : AppColors.cardBackground;
    final fg = mine ? AppColors.white : AppColors.textPrimary;
    final align = mine ? Alignment.centerRight : Alignment.centerLeft;

    return Align(
      alignment: align,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        child: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(AppRadius.r16),
              topRight: const Radius.circular(AppRadius.r16),
              bottomLeft:
                  mine ? const Radius.circular(AppRadius.r16) : Radius.zero,
              bottomRight:
                  mine ? Radius.zero : const Radius.circular(AppRadius.r16),
            ),
            border: mine
                ? null
                : Border.all(color: AppColors.borderDefault),
          ),
          child: Column(
            crossAxisAlignment:
                mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              if (!mine && (message.senderName ?? '').isNotEmpty) ...[
                Text(
                  '${message.senderName!}${message.isAi ? ' (AI)' : ''}',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textWeak,
                  ),
                ),
                const SizedBox(height: 2),
              ],
              Text(
                message.content,
                style: TextStyle(
                  fontSize: 14,
                  color: fg,
                  height: 1.35,
                ),
              ),
              if (message.createdAt != null) ...[
                const SizedBox(height: 4),
                Text(
                  _fmtTime(message.createdAt!),
                  style: TextStyle(
                    fontSize: 10,
                    color: mine
                        ? AppColors.white.withValues(alpha: 0.75)
                        : AppColors.textWeak,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  static String _fmtTime(DateTime when) {
    final hh = when.hour.toString().padLeft(2, '0');
    final mm = when.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }
}

class _EmptyHint extends StatelessWidget {
  const _EmptyHint();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(AppRadius.r16),
              ),
              child: const Icon(
                Icons.forum_outlined,
                size: 40,
                color: AppColors.brandOrange,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            const Text(
              'Say hi to get started',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'An agent will jump in shortly. For faster answers include your\nICCID or order number.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorBar extends StatelessWidget {
  const _ErrorBar({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.pageHorizontal,
        vertical: 6,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.errorBg,
        borderRadius: BorderRadius.circular(AppRadius.r10),
        border: Border.all(color: AppColors.errorBorder),
      ),
      child: Text(
        message,
        style: const TextStyle(
          color: AppColors.error,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _Composer extends StatelessWidget {
  const _Composer({
    required this.controller,
    required this.onSend,
    required this.disabled,
  });
  final TextEditingController controller;
  final VoidCallback onSend;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pageHorizontal,
        AppSpacing.sm,
        AppSpacing.pageHorizontal,
        AppSpacing.md,
      ),
      decoration: const BoxDecoration(
        color: AppColors.cardBackground,
        border: Border(top: BorderSide(color: AppColors.borderDefault)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                enabled: !disabled,
                minLines: 1,
                maxLines: 4,
                textInputAction: TextInputAction.newline,
                decoration: InputDecoration(
                  hintText: 'Type your message…',
                  hintStyle: const TextStyle(
                    color: AppColors.textWeak,
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: AppColors.background,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.r16),
                    borderSide:
                        const BorderSide(color: AppColors.borderDefault),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.r16),
                    borderSide:
                        const BorderSide(color: AppColors.borderDefault),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.r16),
                    borderSide: const BorderSide(
                      color: AppColors.brandOrange,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Material(
              color: disabled ? AppColors.textWeak : AppColors.brandOrange,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: disabled ? null : onSend,
                child: const SizedBox(
                  width: 44,
                  height: 44,
                  child: Icon(
                    Icons.send_rounded,
                    color: AppColors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Convenience opener used by ContactUsPage.
extension LiveChatPageRoute on BuildContext {
  void openLiveChat() => push('/live-chat');
}
