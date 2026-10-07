import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app_providers.dart';
import '../util/ui_util.dart';
import '../widgets/buttons.dart';
import 'ai_chat_notifier.dart';
import 'gemini_service.dart';

class AiSettingsDialog extends ConsumerStatefulWidget {
  const AiSettingsDialog({super.key});

  @override
  ConsumerState<AiSettingsDialog> createState() => _AiSettingsDialogState();
}

class _AiSettingsDialogState extends ConsumerState<AiSettingsDialog> {
  late final TextEditingController _controller;
  late String _selectedModel;

  @override
  void initState() {
    super.initState();
    final service = ref.read(geminiServiceProvider);
    _controller = TextEditingController(text: service.apiKey);
    _selectedModel = service.selectedModel;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _getModelDisplayName(String model) {
    switch (model) {
      case 'gemini-3.5-flash':
        return 'Sedra Assistant Core (Default)';
      case 'gemini-3.5-flash-lite':
        return 'Sedra Assistant Lite (Fast)';
      case 'gemini-3.6-flash':
        return 'Sedra Assistant v1.1';
      case 'gemini-3.7-flash':
        return 'Sedra Assistant v2.0';
      case 'gemini-3.8-flash':
        return 'Sedra Assistant Ultra';
      default:
        return 'Sedra Assistant';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    final styles = ref.watch(stylesProvider);
    String? localeStr;
    try {
      localeStr = ref.watch(languageProvider).getLocaleString();
    } catch (_) {}
    final isIndo = (localeStr ?? 'id').startsWith('id') ||
        (localeStr ?? 'id').startsWith('ms');

    Future<void> saveKey() async {
      final key = _controller.text.trim();
      final service = ref.read(geminiServiceProvider);
      await service.setModel(_selectedModel);
      if (key.isEmpty) {
        await service.resetApiKey();
        UIUtil.showSnackbar(
          isIndo
              ? 'Pengaturan Assistant direset ke default.'
              : 'Assistant settings reset to default.',
        );
      } else {
        await service.setApiKey(key);
        UIUtil.showSnackbar(
          isIndo
              ? 'Pengaturan Sedra Assistant berhasil disimpan.'
              : 'Sedra Assistant settings saved successfully.',
        );
      }
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    }

    return Dialog(
      backgroundColor: theme.backgroundDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isIndo ? 'Pengaturan Assistant' : 'Assistant Settings',
                  style: styles.textStyleDialogHeader,
                ),
                IconButton(
                  icon: Icon(Icons.close, color: theme.text),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              isIndo
                  ? 'Masukkan API Key kustom Anda jika tersedia. Jika dikosongkan, aplikasi akan menggunakan konfigurasi bawaan secara otomatis.'
                  : 'Enter your custom API Key if available. If left empty, default built-in configuration will be used automatically.',
              style: styles.textStyleParagraphSmall,
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _controller,
              style: styles.textStyleParagraph,
              decoration: InputDecoration(
                hintText: isIndo ? 'API Key (Opsional)' : 'API Key (Optional)',
                hintStyle: styles.textStyleParagraphSmall,
                filled: true,
                fillColor: theme.backgroundDarkest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: theme.text15),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: theme.text15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: theme.primary),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              isIndo ? 'Versi Engine' : 'Engine Version',
              style: styles.textStyleParagraphSmall.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: theme.backgroundDarkest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.text15),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedModel,
                  isExpanded: true,
                  dropdownColor: theme.backgroundDark,
                  icon: Icon(Icons.arrow_drop_down, color: theme.text),
                  style: styles.textStyleParagraph,
                  items: GeminiService.supportedModels.map((model) {
                    return DropdownMenuItem<String>(
                      value: model,
                      child: Text(
                        _getModelDisplayName(model),
                        style: styles.textStyleParagraph,
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _selectedModel = val;
                      });
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    title: isIndo ? 'Simpan' : 'Save',
                    onPressed: saveKey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
