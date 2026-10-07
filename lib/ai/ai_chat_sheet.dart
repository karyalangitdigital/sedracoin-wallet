import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app_providers.dart';
import '../util/ui_util.dart';
import '../util/util.dart';
import '../widgets/app_copy_icon.dart';
import '../widgets/app_send_icon.dart';
import '../widgets/app_stop_icon.dart';
import 'ai_chat_message.dart';
import 'ai_chat_notifier.dart';
import 'ai_settings_dialog.dart';
import 'sedra_knowledge_base.dart';

typedef AiChatScreen = AiChatSheet;

class AiChatSheet extends ConsumerStatefulWidget {
  const AiChatSheet({super.key});

  @override
  ConsumerState<AiChatSheet> createState() => _AiChatSheetState();
}

class _AiChatSheetState extends ConsumerState<AiChatSheet> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom({bool force = false}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      final currentScroll = _scrollController.position.pixels;
      if (force || currentScroll < 80) {
        if (currentScroll > 1.0) {
          _scrollController.animateTo(
            0.0,
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOutQuad,
          );
        }
      }
    });
  }

  void _sendMessage([String? customText]) {
    final text = customText ?? _textController.text;
    if (text.trim().isEmpty) return;

    if (customText == null) {
      _textController.clear();
    }

    _focusNode.unfocus();
    FocusScope.of(context).unfocus();

    String? langCode;
    String? langName;
    try {
      final language = ref.read(languageProvider);
      langCode = language.getLocaleString();
      langName = language.language.descriptiveName;
    } catch (_) {}

    ref.read(aiChatProvider.notifier).sendMessage(
      text,
      languageCode: langCode,
      languageName: langName,
    );
    _scrollToBottom(force: true);
  }

  void _showSettings() {
    showDialog(
      context: context,
      builder: (_) => const AiSettingsDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    final styles = ref.watch(stylesProvider);
    final chatState = ref.watch(aiChatProvider);
    String? localeStr;
    try {
      localeStr = ref.watch(languageProvider).getLocaleString();
    } catch (_) {}

    ref.listen(aiChatProvider, (_, _) => _scrollToBottom());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(aiChatProvider.notifier).syncWelcomeMessage(localeStr);
      }
    });

    return Scaffold(
      backgroundColor: theme.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation Bar
            Padding(
              padding: const EdgeInsets.only(left: 4, right: 10, top: 4, bottom: 4),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios_new_rounded, color: theme.text, size: 20),
                    tooltip: 'Back',
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.asset('assets/sedra.png', fit: BoxFit.cover),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Sedra Assistant',
                          style: styles.textStyleDialogHeader.copyWith(
                            fontSize: 16.0,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          SedraKnowledgeBase.getSubtitle(localeStr),
                          style: styles.textStyleParagraphSmall.copyWith(
                            fontSize: 11.0,
                            color: theme.primary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.refresh, color: theme.text, size: 22),
                    tooltip: 'Reset Chat',
                    onPressed: () {
                      ref.read(aiChatProvider.notifier).clearHistory(localeStr);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.settings_outlined, color: theme.text, size: 22),
                    tooltip: 'Settings',
                    onPressed: _showSettings,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),

          // Quick Suggestion Chips
          SizedBox(
            height: 44,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              scrollDirection: Axis.horizontal,
              itemCount: SedraKnowledgeBase.getQuickSuggestions(localeStr).length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final suggestions = SedraKnowledgeBase.getQuickSuggestions(localeStr);
                final suggestion = suggestions[index];
                return ActionChip(
                  label: Text(
                    suggestion,
                    style: styles.textStyleParagraphSmall.copyWith(
                      fontSize: 12.0,
                      color: theme.primary,
                    ),
                  ),
                  backgroundColor: theme.backgroundDarkest,
                  side: BorderSide(color: theme.primary30, width: 0.8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  onPressed: () => _sendMessage(suggestion),
                );
              },
            ),
          ),

          // Message List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              reverse: true,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: chatState.messages.length + (chatState.isThinking ? 1 : 0),
              itemBuilder: (context, index) {
                final hasThinking = chatState.isThinking;
                if (hasThinking && index == 0) {
                  return _buildLoadingBubble(theme, styles);
                }
                final messageIndex = hasThinking
                    ? chatState.messages.length - index
                    : chatState.messages.length - 1 - index;
                if (messageIndex < 0 || messageIndex >= chatState.messages.length) {
                  return const SizedBox.shrink();
                }
                final message = chatState.messages[messageIndex];
                final isLast = messageIndex == chatState.messages.length - 1;
                final isGeneratingThis = isLast && (chatState.isGenerating || chatState.isThinking);
                return _buildMessageBubble(
                  message,
                  theme,
                  styles,
                  isGenerating: isGeneratingThis,
                  localeStr: localeStr,
                );
              },
            ),
          ),

          // Input Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: theme.backgroundDark,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: theme.backgroundDarkest,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: theme.text15, width: 0.5),
              ),
              padding: const EdgeInsets.only(left: 16, right: 6, top: 4, bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      focusNode: _focusNode,
                      style: styles.textStyleParagraph,
                      maxLines: 4,
                      minLines: 1,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                      decoration: InputDecoration(
                        hintText: SedraKnowledgeBase.getInputHint(localeStr),
                        hintStyle: styles.textStyleParagraphSmall.copyWith(
                          color: theme.text30,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: chatState.isGenerating
                        ? () => ref.read(aiChatProvider.notifier).stopGeneration()
                        : () => _sendMessage(),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: theme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: chatState.isGenerating
                            ? AppStopIcon(
                                size: 18,
                                color: theme.backgroundDark,
                              )
                            : AppSendIcon(
                                size: 18,
                                color: theme.backgroundDark,
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildLoadingBubble(dynamic theme, dynamic styles) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: AiTypingDots(color: theme.primary, size: 8.0),
    );
  }

  Widget _buildMessageBubble(
    AiChatMessage message,
    dynamic theme,
    dynamic styles, {
    bool isGenerating = false,
    String? localeStr,
  }) {
    final isUser = message.role == ChatRole.user;

    if (!isUser) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/sedra.png',
                    width: 16,
                    height: 16,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'Sedra Assistant',
                  style: styles.textStyleParagraphSmall.copyWith(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: theme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            MarkdownBody(
              data: message.text,
              selectable: true,
              onTapLink: (text, href, title) {
                if (href != null && href.isNotEmpty) {
                  openUrl(href);
                }
              },
              styleSheet: MarkdownStyleSheet(
                p: styles.textStyleParagraph.copyWith(
                  fontSize: 15.0,
                  height: 1.5,
                  color: message.isError ? Colors.redAccent : theme.text,
                ),
                strong: styles.textStyleParagraph.copyWith(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  color: message.isError ? Colors.redAccent : theme.text,
                ),
                em: styles.textStyleParagraph.copyWith(
                  fontSize: 15.0,
                  fontStyle: FontStyle.italic,
                  color: message.isError ? Colors.redAccent : theme.text,
                ),
                h1: styles.textStyleHeader.copyWith(
                  fontSize: 19.0,
                  fontWeight: FontWeight.bold,
                  color: theme.primary,
                ),
                h2: styles.textStyleHeader.copyWith(
                  fontSize: 17.0,
                  fontWeight: FontWeight.bold,
                  color: theme.primary,
                ),
                h3: styles.textStyleHeader.copyWith(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: theme.primary,
                ),
                h4: styles.textStyleParagraph.copyWith(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  color: theme.text,
                ),
                h5: styles.textStyleParagraph.copyWith(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: theme.text,
                ),
                h6: styles.textStyleParagraph.copyWith(
                  fontSize: 13.0,
                  fontWeight: FontWeight.bold,
                  color: theme.text,
                ),
                a: styles.textStyleParagraph.copyWith(
                  fontSize: 15.0,
                  color: theme.primary,
                  decoration: TextDecoration.underline,
                ),
                code: TextStyle(
                  fontFamily: 'RobotoMono',
                  fontSize: 13.5,
                  color: theme.primary,
                  backgroundColor: theme.backgroundDarkest,
                ),
                codeblockDecoration: BoxDecoration(
                  color: theme.backgroundDarkest,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: theme.text15, width: 0.5),
                ),
                codeblockPadding: const EdgeInsets.all(12),
                blockquote: styles.textStyleParagraph.copyWith(
                  fontSize: 14.0,
                  color: theme.text60,
                  fontStyle: FontStyle.italic,
                ),
                blockquoteDecoration: BoxDecoration(
                  border: Border(left: BorderSide(color: theme.primary, width: 3)),
                ),
                blockquotePadding: const EdgeInsets.only(left: 12, top: 4, bottom: 4),
                listBullet: styles.textStyleParagraph.copyWith(
                  fontSize: 15.0,
                  color: theme.primary,
                ),
                horizontalRuleDecoration: BoxDecoration(
                  border: Border(top: BorderSide(color: theme.text15, width: 0.5)),
                ),
              ),
            ),
            if (!isGenerating && message.text.isNotEmpty) ...[
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: message.text));
                    UIUtil.showSnackbar(SedraKnowledgeBase.getCopySnackbar(localeStr));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppCopyIcon(color: theme.text60, size: 14),
                        const SizedBox(width: 6),
                        Text(
                          SedraKnowledgeBase.getCopyLabel(localeStr),
                          style: styles.textStyleParagraphSmall.copyWith(
                            fontSize: 11.0,
                            color: theme.text60,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    }

    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.82,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: theme.primary15,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(4),
          ),
        ),
        child: SelectableText(
          message.text,
          style: styles.textStyleParagraph.copyWith(
            fontSize: 14.0,
            height: 1.4,
            color: theme.text,
          ),
        ),
      ),
    );
  }
}

class AiTypingDots extends StatefulWidget {
  final Color color;
  final double size;

  const AiTypingDots({
    super.key,
    required this.color,
    this.size = 7.0,
  });

  @override
  State<AiTypingDots> createState() => _AiTypingDotsState();
}

class _AiTypingDotsState extends State<AiTypingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value;
        final scale1 = 0.35 + 0.65 * (0.5 + 0.5 * math.sin(t * 2 * math.pi));
        final scale2 = 0.35 + 0.65 * (0.5 + 0.5 * math.sin((t * 2 * math.pi) - (2 * math.pi / 3)));
        final scale3 = 0.35 + 0.65 * (0.5 + 0.5 * math.sin((t * 2 * math.pi) - (4 * math.pi / 3)));

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Transform.scale(
              scale: scale1,
              child: Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  color: widget.color,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            const SizedBox(width: 5),
            Transform.scale(
              scale: scale2,
              child: Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  color: widget.color,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            const SizedBox(width: 5),
            Transform.scale(
              scale: scale3,
              child: Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  color: widget.color,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

