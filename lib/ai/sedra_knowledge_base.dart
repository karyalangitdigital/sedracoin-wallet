class SedraKnowledgeBase {
  static String resolveLanguage(String? languageCode) {
    if (languageCode == null ||
        languageCode.trim().isEmpty ||
        languageCode.toLowerCase() == 'default') {
      return 'en';
    }
    return languageCode.toLowerCase();
  }

  static String getSystemInstruction({
    String? languageCode,
    String? languageName,
  }) {
    final code = resolveLanguage(languageCode);
    final name = (languageName != null &&
            languageName.isNotEmpty &&
            languageName != 'Default')
        ? languageName
        : (code == 'id' ? 'Bahasa Indonesia' : 'English');

    return '''
You are Sedra Assistant, a dedicated AI assistant for the Sedra (SDR) ecosystem.

CORE PRINCIPLES & IDENTITY:
1. STRICT IDENTITY & VENDOR CONFIDENTIALITY:
   - NEVER mention, acknowledge, or leak the names of underlying models, vendors, or creators (such as Google, Gemini, OpenAI, ChatGPT, Claude, Anthropic, Meta, Llama, etc.).
   - If asked about who made you, what model you use, or if you are ChatGPT/Gemini: ALWAYS politely and firmly answer that you are "Sedra Assistant", a specialized AI assistant built to help users in the Sedra ecosystem.
   - Your sole identity name is "Sedra Assistant".

2. LANGUAGE ADAPTATION (CRITICAL):
   - The user's active wallet language is: $name (code: $code).
   - ALWAYS respond fluently, naturally, and accurately in $name (unless the user explicitly types in or requests a different language).

3. ACCURACY & ZERO-HALLUCINATION POLICY:
   - All information MUST be 100% factual and adhere strictly to official Sedra documentation (https://sedracoin.com/), BlockDAG & GHOSTDAG architecture, and explorers.
   - NEVER hallucinate fake metrics, incorrect supply figures, or non-existent features.
   - Transparent research status: If a technology is still in research/testnet (e.g. smart contracts, ecosystem upgrades), state its status clearly and transparently.
   - Not financial advice: When asked about price, focus on technical fundamentals, tokenomics, emission schedules, and BlockDAG architecture.

4. COMPREHENSIVE SEDRA KNOWLEDGE BASE:
   - **Sedra Nature**: Fastest, open-source, decentralized proof-of-work (PoW) layer-1 cryptocurrency utilizing innovative BlockDAG (Directed Acyclic Graph) architecture based on GHOSTDAG consensus.
   - **GHOSTDAG Consensus**: Allows parallel blocks to coexist without orphan blocks, sorting honest blue blocks from red attacker blocks deterministically into a total ordering consensus.
   - **Throughput & Speed**: Rapid block generation and near-instant transaction finality with sub-second confirmations.
   - **Tokenomics**: Symbol SDR, fair launch, decentralized emission schedule designed for long-term sustainability.
   - **Mining**: kHeavyHash PoW mining algorithm, ASIC and GPU compatible.
   - **UTXO Management**: Compound UTXO feature to merge small mining/transfer UTXOs into 1 large UTXO for optimal wallet speed and low fees.
   - **Ecosystem & Smart Assets**: Innovative ecosystem supporting decentralized tokens, smart services, and high-performance Web3 applications.

5. FORMATTING & STYLE:
   - Respond in well-structured Markdown (headings, bullet points, bold key terms, blockquotes, code blocks).
   - Ensure clean and mobile-friendly formatting.

6. STRICT TOPIC RESTRICTION:
   - YOU MUST ONLY DISCUSS topics directly related to Sedra, SDR, BlockDAG, GHOSTDAG, kHeavyHash, cryptocurrency mining, tokenomics, or this wallet application.
   - If a user asks about general programming, cooking, history, other non-crypto topics, or other cryptocurrencies (unless compared directly to Sedra), politely decline and state that you are exclusively an assistant for the Sedra ecosystem.
''';
  }

  static String getSubtitle(String? languageCode) {
    final code = resolveLanguage(languageCode);
    if (code.startsWith('id') || code.startsWith('ms')) {
      return 'Asisten Ekosistem Sedra';
    } else if (code.startsWith('es')) {
      return 'Asistente del Ecosistema Sedra';
    } else if (code.startsWith('fr')) {
      return 'Assistant de l\'écosystème Sedra';
    } else if (code.startsWith('de')) {
      return 'Sedra-Ökosystem-Assistent';
    } else if (code.startsWith('ru')) {
      return 'Ассистент экосистемы Sedra';
    } else if (code.startsWith('zh')) {
      return 'Sedra 生态智能助手';
    } else if (code.startsWith('ja')) {
      return 'Sedra エコシステムアシスタント';
    } else if (code.startsWith('ko')) {
      return 'Sedra 생태계 어시스턴트';
    } else if (code.startsWith('pt')) {
      return 'Assistente do Ecossistema Sedra';
    } else if (code.startsWith('it')) {
      return 'Assistente dell\'ecosistema Sedra';
    } else if (code.startsWith('tr')) {
      return 'Sedra Ekosistem Asistanı';
    } else {
      return 'Sedra Ecosystem Assistant';
    }
  }

  static String getInputHint(String? languageCode) {
    final code = resolveLanguage(languageCode);
    if (code.startsWith('id') || code.startsWith('ms')) {
      return 'Tanyakan seputar Sedra...';
    } else if (code.startsWith('es')) {
      return 'Pregunta sobre Sedra...';
    } else if (code.startsWith('fr')) {
      return 'Posez une question sur Sedra...';
    } else if (code.startsWith('de')) {
      return 'Frage etwas über Sedra...';
    } else if (code.startsWith('ru')) {
      return 'Спросите о Sedra...';
    } else if (code.startsWith('zh')) {
      return '询问关于 Sedra 的问题...';
    } else if (code.startsWith('ja')) {
      return 'Sedra について質問...';
    } else if (code.startsWith('ko')) {
      return 'Sedra에 대해 질문하세요...';
    } else if (code.startsWith('pt')) {
      return 'Pergunte sobre a Sedra...';
    } else if (code.startsWith('it')) {
      return 'Chiedi informazioni su Sedra...';
    } else if (code.startsWith('tr')) {
      return 'Sedra hakkında soru sorun...';
    } else {
      return 'Ask anything about Sedra...';
    }
  }

  static String getCopyLabel(String? languageCode) {
    final code = resolveLanguage(languageCode);
    if (code.startsWith('id') || code.startsWith('ms')) {
      return 'Salin';
    } else if (code.startsWith('es')) {
      return 'Copiar';
    } else if (code.startsWith('fr')) {
      return 'Copier';
    } else if (code.startsWith('de')) {
      return 'Kopieren';
    } else if (code.startsWith('ru')) {
      return 'Копировать';
    } else if (code.startsWith('zh')) {
      return '复制';
    } else if (code.startsWith('ja')) {
      return 'コピー';
    } else if (code.startsWith('ko')) {
      return '복사';
    } else if (code.startsWith('pt')) {
      return 'Copiar';
    } else if (code.startsWith('it')) {
      return 'Copia';
    } else if (code.startsWith('tr')) {
      return 'Kopyala';
    } else {
      return 'Copy';
    }
  }

  static String getCopySnackbar(String? languageCode) {
    final code = resolveLanguage(languageCode);
    if (code.startsWith('id') || code.startsWith('ms')) {
      return 'Jawaban AI disalin.';
    } else if (code.startsWith('es')) {
      return 'Respuesta copiada.';
    } else if (code.startsWith('fr')) {
      return 'Réponse copiée.';
    } else if (code.startsWith('de')) {
      return 'Antwort kopiert.';
    } else if (code.startsWith('ru')) {
      return 'Ответ скопирован.';
    } else if (code.startsWith('zh')) {
      return '回答已复制。';
    } else if (code.startsWith('ja')) {
      return '回答をコピーしました。';
    } else if (code.startsWith('ko')) {
      return '답변이 복사되었습니다.';
    } else if (code.startsWith('pt')) {
      return 'Resposta copiada.';
    } else if (code.startsWith('it')) {
      return 'Risposta copiata.';
    } else if (code.startsWith('tr')) {
      return 'Cevap kopyalandı.';
    } else {
      return 'AI response copied.';
    }
  }

  static List<String> getQuickSuggestions(String? languageCode) {
    final code = resolveLanguage(languageCode);
    if (code.startsWith('id') || code.startsWith('ms')) {
      return [
        'Apa itu Sedra & BlockDAG?',
        'Bagaimana arsitektur GHOSTDAG di Sedra?',
        'Berapa max supply & jadwal emisi SDR?',
        'Apa fungsi fitur Compound UTXO?',
        'Bagaimana cara mining Sedra?',
      ];
    } else if (code.startsWith('es')) {
      return [
        '¿Qué es Sedra y BlockDAG?',
        '¿Cómo funciona la arquitectura de Sedra?',
        '¿Cuál es el suministro y emisión de SDR?',
        '¿Qué es la función Compound UTXO?',
        '¿Cómo minar Sedra?',
      ];
    } else if (code.startsWith('fr')) {
      return [
        "Qu'est-ce que Sedra et BlockDAG ?",
        'Comment fonctionne l\'architecture Sedra ?',
        "Quel est l'approvisionnement de SDR ?",
        'À quoi sert Compound UTXO ?',
        'Comment miner du Sedra ?',
      ];
    } else if (code.startsWith('de')) {
      return [
        'Was ist Sedra & BlockDAG?',
        'Wie funktioniert die Sedra-Architektur?',
        'Was ist das Angebot von SDR?',
        'Was ist die Compound UTXO-Funktion?',
        'Wie schürft man Sedra?',
      ];
    } else if (code.startsWith('ru')) {
      return [
        'Что такое Sedra и BlockDAG?',
        'Как работает архитектура Sedra?',
        'Какова эмиссия SDR?',
        'Что такое Compound UTXO?',
        'Как майнить Sedra?',
      ];
    } else if (code.startsWith('zh')) {
      return [
        '什么是 Sedra 和 BlockDAG？',
        'Sedra 的 GHOSTDAG 架构如何工作？',
        'SDR 的代币经济与供应量是多少？',
        '什么是 Compound UTXO 功能？',
        '如何进行 Sedra 挖矿？',
      ];
    } else if (code.startsWith('ja')) {
      return [
        'Sedra と BlockDAG とは？',
        'Sedra のアーキテクチャの仕組みは？',
        'SDR の供給量と発行スケジュールは？',
        'Compound UTXO 機能とは？',
        'Sedra のマイニング方法は？',
      ];
    } else if (code.startsWith('ko')) {
      return [
        'Sedra 및 BlockDAG란 무엇인가요?',
        'Sedra의 GHOSTDAG 작동 방식은?',
        'SDR 공급량 및 발행 일정은?',
        'Compound UTXO 기능이란?',
        'Sedra 채굴 방법은?',
      ];
    } else if (code.startsWith('pt')) {
      return [
        'O que é Sedra e BlockDAG?',
        'Como funciona a arquitetura da Sedra?',
        'Qual é o fornecimento de SDR?',
        'O que é o recurso Compound UTXO?',
        'Como minerar Sedra?',
      ];
    } else {
      return [
        'What is Sedra & BlockDAG?',
        'How does GHOSTDAG consensus work in Sedra?',
        'What is SDR tokenomics & supply schedule?',
        'What is the Compound UTXO feature?',
        'How to mine Sedra?',
      ];
    }
  }

  static String getWelcomeMessage(String? languageCode) {
    final code = resolveLanguage(languageCode);
    if (code.startsWith('id') || code.startsWith('ms')) {
      return 'Halo! Saya **Sedra Assistant**. Tanyakan apa saja seputar teknologi **Sedra**, arsitektur **BlockDAG / GHOSTDAG**, tokenomics SDR, mining, maupun panduan dompet ini! 🚀';
    } else if (code.startsWith('es')) {
      return '¡Hola! Soy **Sedra Assistant**. ¡Pregúntame lo que sea sobre la tecnología **Sedra**, la arquitectura **BlockDAG / GHOSTDAG**, tokenomics de SDR, minería o tu billetera! 🚀';
    } else if (code.startsWith('fr')) {
      return 'Bonjour ! Je suis **Sedra Assistant**. Posez-moi vos questions sur la technologie **Sedra**, l\'architecture **BlockDAG / GHOSTDAG**, les tokenomics SDR, le minage ou ce portefeuille ! 🚀';
    } else if (code.startsWith('de')) {
      return 'Hallo! Ich bin **Sedra Assistant**. Frag mich alles über die **Sedra**-Technologie, **BlockDAG / GHOSTDAG**, SDR Tokenomics, Mining oder diese Wallet! 🚀';
    } else if (code.startsWith('ru')) {
      return 'Привет! Я **Sedra Assistant**. Спрашивайте обо всем, что касается технологий **Sedra**, **BlockDAG / GHOSTDAG**, токеномики SDR, майнинга или кошелька! 🚀';
    } else if (code.startsWith('zh')) {
      return '您好！我是 **Sedra Assistant**。欢迎随时向我咨询关于 **Sedra** 技术、**BlockDAG / GHOSTDAG** 架构、SDR 经济模型、挖矿或钱包使用指南！🚀';
    } else if (code.startsWith('ja')) {
      return 'こんにちは！**Sedra Assistant** です。**Sedra** の技術、**BlockDAG / GHOSTDAG** アーキテクチャ、SDR トークノミクス、マイニング、ウォレットの使い方など、何でもお気軽にご質問ください！🚀';
    } else if (code.startsWith('ko')) {
      return '안녕하세요! **Sedra Assistant**입니다. **Sedra** 기술, **BlockDAG / GHOSTDAG** 아키텍처, SDR 토크노믹스, 채굴 또는 지갑 가이드에 대해 무엇이든 물어보세요! 🚀';
    } else if (code.startsWith('pt')) {
      return 'Olá! Eu sou o **Sedra Assistant**. Pergunte-me qualquer coisa sobre a tecnologia **Sedra**, arquitetura **BlockDAG / GHOSTDAG**, tokenomics SDR, mineração ou esta carteira! 🚀';
    } else {
      return 'Hello! I am **Sedra Assistant**. Ask me anything about **Sedra** technology, **BlockDAG / GHOSTDAG** architecture, SDR tokenomics, mining, or this wallet! 🚀';
    }
  }

  static String getResetMessage(String? languageCode) {
    final code = resolveLanguage(languageCode);
    if (code.startsWith('id') || code.startsWith('ms')) {
      return 'Percakapan telah direset. Ada yang ingin Anda tanyakan seputar **Sedra** atau dompet ini?';
    } else if (code.startsWith('es')) {
      return 'La conversación ha sido reiniciada. ¿Hay algo que desees preguntar sobre **Sedra** o esta billetera?';
    } else if (code.startsWith('fr')) {
      return 'La conversation a été réinitialisée. Avez-vous des questions sur **Sedra** ou ce portefeuille ?';
    } else if (code.startsWith('de')) {
      return 'Die Unterhaltung wurde zurückgesetzt. Gibt es etwas, das du über **Sedra** oder diese Wallet wissen möchtest?';
    } else if (code.startsWith('ru')) {
      return 'Разговор сброшен. Хотите спросить что-нибудь о **Sedra** или этом кошельке?';
    } else if (code.startsWith('zh')) {
      return '对话已重置。关于 **Sedra** 或此钱包，您有什么想了解的吗？';
    } else if (code.startsWith('ja')) {
      return '会話がリセットされました。**Sedra** またはこのウォレットについて質問はありますか？';
    } else if (code.startsWith('ko')) {
      return '대화가 초기화되었습니다. **Sedra** 또는 이 지갑에 대해 궁금한 점이 있으신가요?';
    } else if (code.startsWith('pt')) {
      return 'A conversa foi reiniciada. Tem algo que queira perguntar sobre a **Sedra** ou esta carteira?';
    } else {
      return 'Conversation reset. Is there anything you would like to ask about **Sedra** or this wallet?';
    }
  }
}
