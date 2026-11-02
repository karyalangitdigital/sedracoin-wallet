import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app_providers.dart';
import '../util/ui_util.dart';
import '../widgets/buttons.dart';
import 'ai_chat_notifier.dart';

class AiSettingsDialog extends ConsumerStatefulWidget {
  const AiSettingsDialog({super.key});

  @override
  ConsumerState<AiSettingsDialog> createState() => _AiSettingsDialogState();
}

class _AiSettingsDialogState extends ConsumerState<AiSettingsDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final service = ref.read(geminiServiceProvider);
    _controller = TextEditingController(text: service.apiKey);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    final styles = ref.watch(stylesProvider);
    String? localeStr;
    try {
      localeStr = ref.watch(languageProvider).getLocaleString();
    } catch (_) {}
    final isIndo =
        (localeStr ?? 'id').startsWith('id') ||
        (localeStr ?? 'id').startsWith('ms');

    Future<void> saveKey() async {
      final key = _controller.text.trim();
      final service = ref.read(geminiServiceProvider);
      if (key.isEmpty) {
        await service.clearApiKey();
        UIUtil.showSnackbar(
          isIndo
              ? 'API key dihapus. Assistant nonaktif sampai Anda memasukkan API key sendiri.'
              : 'API key removed. The assistant is disabled until you enter your own API key.',
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
                  ? 'Sedra Assistant memakai API key pribadi Anda — tidak ada key bawaan. Buat key gratis di aistudio.google.com/apikey lalu masukkan di bawah ini. Pemakaian dan kuota sepenuhnya mengikuti akun Google Anda.'
                  : 'Sedra Assistant uses your own personal API key — there is no built-in key. Create a free key at aistudio.google.com/apikey and paste it below. Usage and quotas follow your own Google account.',
              style: styles.textStyleParagraphSmall,
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _controller,
              style: styles.textStyleParagraph,
              decoration: InputDecoration(
                hintText: isIndo
                    ? 'Masukkan API Key Google AI Studio Anda'
                    : 'Enter your Google AI Studio API Key',
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
