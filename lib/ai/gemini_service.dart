import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'ai_chat_message.dart';
import 'sedra_knowledge_base.dart';

class GeminiService {
  static const String _defaultApiKey = 'AQ.Ab8RN6LoHIani4bglOtxSakSpsGXN9lLNSan0EDBxY2WgVpNgg';
  static const String _prefApiKey = 'sedra_gemini_api_key';
  static const String _prefModel = 'sedra_gemini_model';
  static const String defaultModel = 'gemini-3.5-flash';

  static const List<String> supportedModels = [
    'gemini-3.5-flash',
    'gemini-3.5-flash-lite',
    'gemini-3.6-flash',
    'gemini-3.7-flash',
    'gemini-3.8-flash',
  ];

  final SharedPreferences? _prefs;

  GeminiService([this._prefs]);

  String get apiKey {
    final customKey = _prefs?.getString(_prefApiKey);
    if (customKey != null && customKey.trim().isNotEmpty) {
      return customKey.trim();
    }
    return _defaultApiKey;
  }

  String get selectedModel {
    final model = _prefs?.getString(_prefModel);
    if (model != null && model.trim().isNotEmpty) {
      return model.trim();
    }
    return defaultModel;
  }

  Future<void> setModel(String model) async {
    if (_prefs != null) {
      await _prefs.setString(_prefModel, model.trim());
    }
  }

  Future<void> setApiKey(String key) async {
    if (_prefs != null) {
      await _prefs.setString(_prefApiKey, key.trim());
    }
  }

  Future<void> resetApiKey() async {
    if (_prefs != null) {
      await _prefs.remove(_prefApiKey);
      await _prefs.remove(_prefModel);
    }
  }

  Future<String> generateSedraResponse({
    required String userPrompt,
    required List<AiChatMessage> history,
    String? systemInstructionText,
  }) async {
    final key = apiKey;
    final primaryModel = selectedModel;

    // List of models to try in sequence if one is unavailable
    final modelsToTry = <String>[
      primaryModel,
      ...supportedModels.where((m) => m != primaryModel),
    ];

    final contents = <Map<String, dynamic>>[];

    // System instruction
    final instruction = systemInstructionText ?? SedraKnowledgeBase.getSystemInstruction();
    final systemInstruction = {
      'role': 'user',
      'parts': [
        {'text': instruction},
      ],
    };
    final systemAck = {
      'role': 'model',
      'parts': [
        {
          'text':
              'Understood. I am Sedra Assistant, ready to help users with the Sedra ecosystem accurately and concisely in their selected language.',
        },
      ],
    };

    contents.add(systemInstruction);
    contents.add(systemAck);

    // Add recent conversation history (up to last 10 messages)
    final recentHistory = history.length > 10
        ? history.sublist(history.length - 10)
        : history;

    for (final msg in recentHistory) {
      if (msg.isError) continue;
      contents.add({
        'role': msg.role == ChatRole.user ? 'user' : 'model',
        'parts': [
          {'text': msg.text},
        ],
      });
    }

    // Add current user prompt
    contents.add({
      'role': 'user',
      'parts': [
        {'text': userPrompt},
      ],
    });

    final requestBody = {
      'contents': contents,
      'generationConfig': {
        'temperature': 0.3,
        'topK': 40,
        'topP': 0.95,
        'maxOutputTokens': 2048,
      },
      'safetySettings': [
        {
          'category': 'HARM_CATEGORY_HARASSMENT',
          'threshold': 'BLOCK_NONE',
        },
        {
          'category': 'HARM_CATEGORY_HATE_SPEECH',
          'threshold': 'BLOCK_NONE',
        },
        {
          'category': 'HARM_CATEGORY_SEXUALLY_EXPLICIT',
          'threshold': 'BLOCK_NONE',
        },
        {
          'category': 'HARM_CATEGORY_DANGEROUS_CONTENT',
          'threshold': 'BLOCK_NONE',
        },
      ],
    };

    String lastError = '';

    for (final model in modelsToTry) {
      final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$key',
      );

      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(requestBody),
        ).timeout(const Duration(seconds: 30));

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body) as Map<String, dynamic>;
          final candidates = data['candidates'] as List<dynamic>?;
          if (candidates != null && candidates.isNotEmpty) {
            final candidate = candidates.first as Map<String, dynamic>;
            final content = candidate['content'] as Map<String, dynamic>?;
            final parts = content?['parts'] as List<dynamic>?;
            if (parts != null && parts.isNotEmpty) {
              final text = parts.first['text'] as String?;
              if (text != null && text.trim().isNotEmpty) {
                return text.trim();
              }
            }
          }
          return 'Maaf, tidak menerima teks balasan dari model $model.';
        } else {
          final errorData = jsonDecode(response.body);
          lastError = errorData['error']?['message'] ?? 'Status ${response.statusCode}';
        }
      } catch (e) {
        lastError = e.toString();
      }
    }

    throw Exception('Gagal menghubungi Gemini API: $lastError');
  }

  Stream<String> streamSedraResponse({
    required String userPrompt,
    required List<AiChatMessage> history,
    String? systemInstructionText,
  }) async* {
    final key = apiKey;
    final primaryModel = selectedModel;

    final modelsToTry = <String>[
      primaryModel,
      ...supportedModels.where((m) => m != primaryModel),
    ];

    final contents = <Map<String, dynamic>>[];

    // System instruction
    final instruction = systemInstructionText ?? SedraKnowledgeBase.getSystemInstruction();
    final systemInstruction = {
      'role': 'user',
      'parts': [
        {'text': instruction},
      ],
    };
    final systemAck = {
      'role': 'model',
      'parts': [
        {
          'text':
              'Understood. I am Sedra Assistant, ready to help users with the Sedra ecosystem accurately and concisely in their selected language.',
        },
      ],
    };

    contents.add(systemInstruction);
    contents.add(systemAck);

    final recentHistory = history.length > 10
        ? history.sublist(history.length - 10)
        : history;

    for (final msg in recentHistory) {
      if (msg.isError) continue;
      contents.add({
        'role': msg.role == ChatRole.user ? 'user' : 'model',
        'parts': [
          {'text': msg.text},
        ],
      });
    }

    contents.add({
      'role': 'user',
      'parts': [
        {'text': userPrompt},
      ],
    });

    final requestBody = {
      'contents': contents,
      'generationConfig': {
        'temperature': 0.3,
        'topK': 40,
        'topP': 0.95,
        'maxOutputTokens': 2048,
      },
      'safetySettings': [
        {
          'category': 'HARM_CATEGORY_HARASSMENT',
          'threshold': 'BLOCK_NONE',
        },
        {
          'category': 'HARM_CATEGORY_HATE_SPEECH',
          'threshold': 'BLOCK_NONE',
        },
        {
          'category': 'HARM_CATEGORY_SEXUALLY_EXPLICIT',
          'threshold': 'BLOCK_NONE',
        },
        {
          'category': 'HARM_CATEGORY_DANGEROUS_CONTENT',
          'threshold': 'BLOCK_NONE',
        },
      ],
    };

    String lastError = '';
    final bodyJson = jsonEncode(requestBody);

    for (final model in modelsToTry) {
      final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/$model:streamGenerateContent?alt=sse&key=$key',
      );

      final client = http.Client();
      try {
        final request = http.Request('POST', url);
        request.headers['Content-Type'] = 'application/json';
        request.body = bodyJson;

        final response = await client.send(request).timeout(const Duration(seconds: 30));

        if (response.statusCode == 200) {
          bool yieldedAny = false;
          final stream = response.stream
              .transform(utf8.decoder)
              .transform(const LineSplitter());

          await for (final line in stream) {
            final trimmed = line.trim();
            if (trimmed.startsWith('data: ')) {
              final jsonStr = trimmed.substring(6).trim();
              if (jsonStr.isEmpty || jsonStr == '[DONE]') continue;
              try {
                final data = jsonDecode(jsonStr) as Map<String, dynamic>;
                final candidates = data['candidates'] as List<dynamic>?;
                if (candidates != null && candidates.isNotEmpty) {
                  final candidate = candidates.first as Map<String, dynamic>;
                  final content = candidate['content'] as Map<String, dynamic>?;
                  final parts = content?['parts'] as List<dynamic>?;
                  if (parts != null && parts.isNotEmpty) {
                    final text = parts.first['text'] as String?;
                    if (text != null && text.isNotEmpty) {
                      yieldedAny = true;
                      yield text;
                    }
                  }
                }
              } catch (_) {}
            }
          }

          if (yieldedAny) {
            client.close();
            return;
          }
        } else {
          final body = await response.stream.bytesToString();
          try {
            final errorData = jsonDecode(body);
            lastError = errorData['error']?['message'] ?? 'Status ${response.statusCode}';
          } catch (_) {
            lastError = 'Status ${response.statusCode}';
          }
        }
      } catch (e) {
        lastError = e.toString();
      } finally {
        client.close();
      }
    }

    // Fallback to non-streaming if needed
    try {
      final fallbackResponse = await generateSedraResponse(
        userPrompt: userPrompt,
        history: history,
      );
      yield fallbackResponse;
      return;
    } catch (_) {}

    throw Exception('Gagal streaming respon Gemini: $lastError');
  }
}
