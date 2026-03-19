class BarAiChat {
  final bool? success;
  final String? message;
  final String? markdown;

  BarAiChat({this.success, this.message, this.markdown});

  factory BarAiChat.fromJson(Map<String, dynamic> json) {
    final aiResponse = json['ai_response'];
    final innerData = aiResponse != null ? aiResponse['data'] : null;

    return BarAiChat(
      success: aiResponse?['success'],
      message: aiResponse?['message'],
      markdown: innerData?['markdown'],
    );
  }
}
