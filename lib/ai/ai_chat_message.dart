enum ChatRole { user, model, system }

class AiChatMessage {
  final String id;
  final ChatRole role;
  final String text;
  final DateTime timestamp;
  final bool isError;

  const AiChatMessage({
    required this.id,
    required this.role,
    required this.text,
    required this.timestamp,
    this.isError = false,
  });

  AiChatMessage copyWith({
    String? id,
    ChatRole? role,
    String? text,
    DateTime? timestamp,
    bool? isError,
  }) {
    return AiChatMessage(
      id: id ?? this.id,
      role: role ?? this.role,
      text: text ?? this.text,
      timestamp: timestamp ?? this.timestamp,
      isError: isError ?? this.isError,
    );
  }
}
