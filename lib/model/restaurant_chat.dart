class RestaurantAiChat {
  final bool? success;
  final String? message;
  final String? markdown;

  RestaurantAiChat({this.success, this.message, this.markdown});

  factory RestaurantAiChat.fromJson(Map<String, dynamic> json) {
    final aiResponse = json['ai_response'];
    final innerData = aiResponse?['data'];

    return RestaurantAiChat(
      success: aiResponse?['success'],
      message: aiResponse?['message'],
      markdown: innerData?['markdown'],
    );
  }
}
