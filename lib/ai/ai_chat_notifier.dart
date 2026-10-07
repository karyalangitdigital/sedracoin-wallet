import 'dart:async';
import 'dart:math' as math;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app_providers.dart';
import 'ai_chat_message.dart';
import 'gemini_service.dart';
import 'sedra_knowledge_base.dart';

final geminiServiceProvider = Provider<GeminiService>((ref) {
  final prefs = ref.watch(sharedPrefsProvider);
  return GeminiService(prefs);
});

class AiChatState {
  final List<AiChatMessage> messages;
  final bool isThinking;
  final bool isGenerating;
  final String? error;

  const AiChatState({
    required this.messages,
    this.isThinking = false,
    this.isGenerating = false,
    this.error,
  });

  bool get isLoading => isThinking || isGenerating;

  AiChatState copyWith({
    List<AiChatMessage>? messages,
    bool? isThinking,
    bool? isGenerating,
    String? error,
  }) {
    return AiChatState(
      messages: messages ?? this.messages,
      isThinking: isThinking ?? this.isThinking,
      isGenerating: isGenerating ?? this.isGenerating,
      error: error,
    );
  }
}

class AiChatNotifier extends StateNotifier<AiChatState> {
  final GeminiService _geminiService;
  bool _isCancelled = false;
  Timer? _typewriterTimer;

  AiChatNotifier(this._geminiService)
      : super(
          const AiChatState(
            messages: [],
          ),
        );

  @override
  void dispose() {
    _typewriterTimer?.cancel();
    super.dispose();
  }

  void stopGeneration() {
    _isCancelled = true;
    _typewriterTimer?.cancel();
    state = state.copyWith(
      isThinking: false,
      isGenerating: false,
    );
  }

  Future<void> sendMessage(
    String text, {
    String? languageCode,
    String? languageName,
  }) async {
    final cleanText = text.trim();
    if (cleanText.isEmpty || state.isGenerating) return;

    _isCancelled = false;
    _typewriterTimer?.cancel();

    final userMessage = AiChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      role: ChatRole.user,
      text: cleanText,
      timestamp: DateTime.now(),
    );

    final updatedMessages = [...state.messages, userMessage];
    state = state.copyWith(
      messages: updatedMessages,
      isThinking: true,
      isGenerating: true,
      error: null,
    );

    final modelMsgId = (DateTime.now().millisecondsSinceEpoch + 1).toString();
    String targetText = '';
    String displayedText = '';
    bool streamCompleted = false;
    bool messageAppended = false;
    final completer = Completer<void>();

    // Start super-fast, buttery-smooth typewriter animation ticker
    _typewriterTimer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      if (_isCancelled) {
        timer.cancel();
        if (!completer.isCompleted) completer.complete();
        return;
      }

      if (displayedText.length < targetText.length) {
        final diff = targetText.length - displayedText.length;
        final int step;
        if (diff > 80) {
          step = 8;
        } else if (diff > 40) {
          step = 5;
        } else if (diff > 15) {
          step = 3;
        } else if (diff > 5) {
          step = 2;
        } else {
          step = 1;
        }

        final nextLen = math.min(displayedText.length + step, targetText.length);
        displayedText = targetText.substring(0, nextLen);

        final modelMessage = AiChatMessage(
          id: modelMsgId,
          role: ChatRole.model,
          text: displayedText,
          timestamp: DateTime.now(),
        );

        if (!messageAppended) {
          messageAppended = true;
          state = state.copyWith(
            messages: [...updatedMessages, modelMessage],
            isThinking: false,
            isGenerating: true,
          );
        } else {
          final current = [...state.messages];
          if (current.isNotEmpty && current.last.id == modelMsgId) {
            current[current.length - 1] = modelMessage;
            state = state.copyWith(messages: current);
          }
        }
      } else if (streamCompleted && displayedText.length >= targetText.length) {
        timer.cancel();
        state = state.copyWith(
          isThinking: false,
          isGenerating: false,
        );
        if (!completer.isCompleted) completer.complete();
      }
    });

    try {
      final systemInstructionText = SedraKnowledgeBase.getSystemInstruction(
        languageCode: languageCode,
        languageName: languageName,
      );

      await for (final chunk in _geminiService.streamSedraResponse(
        userPrompt: cleanText,
        history: updatedMessages,
        systemInstructionText: systemInstructionText,
      )) {
        if (_isCancelled) break;
        targetText += chunk;
      }
      streamCompleted = true;

      await completer.future;
    } catch (e) {
      _typewriterTimer?.cancel();
      if (_isCancelled) {
        state = state.copyWith(
          isThinking: false,
          isGenerating: false,
        );
        return;
      }

      final errorMessage = AiChatMessage(
        id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
        role: ChatRole.model,
        text: '❌ Terjadi kendala saat menghubungi AI: $e\n\nPastikan koneksi internet aktif atau periksa pengaturan API key Anda.',
        timestamp: DateTime.now(),
        isError: true,
      );

      state = state.copyWith(
        messages: [...state.messages, errorMessage],
        isThinking: false,
        isGenerating: false,
        error: e.toString(),
      );
    }
  }

  void clearHistory([String? languageCode]) {
    _isCancelled = true;
    _typewriterTimer?.cancel();
    state = const AiChatState(
      messages: [],
    );
  }

  void syncWelcomeMessage(String? languageCode) {
    if (state.messages.length == 1 && state.messages.first.id == 'welcome') {
      final newText = SedraKnowledgeBase.getWelcomeMessage(languageCode);
      if (state.messages.first.text != newText) {
        state = state.copyWith(
          messages: [
            AiChatMessage(
              id: 'welcome',
              role: ChatRole.model,
              text: newText,
              timestamp: state.messages.first.timestamp,
            ),
          ],
        );
      }
    }
  }
}

final aiChatProvider = StateNotifierProvider<AiChatNotifier, AiChatState>((ref) {
  final service = ref.watch(geminiServiceProvider);
  return AiChatNotifier(service);
});
