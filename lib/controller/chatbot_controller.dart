import 'package:genius_ai/constants/api_constant.dart';
import 'package:genius_ai/model/bar_chat.dart';
import 'package:genius_ai/model/restaurant_chat.dart';
import 'package:genius_ai/services/custom_http.dart';
import 'package:get/get.dart';

class ChatbotController extends GetxController {
  RxBool isLoading = false.obs;

  Future<RestaurantAiChat?> generateRecipeAI(String prompt) async {
    isLoading(true);
    final Map<String, dynamic> body = {"prompt": prompt, "language": "English"};

    try {
      final response = await CustomHttp.post(
        endpoint: ApiConstant.restaurantAiChatBot,
        body: body,
        need_auth: true,
      );

      if (response.ok && response.data != null) {
        return RestaurantAiChat.fromJson(response.data["data"]);
      }
    } finally {
      isLoading(false);
    }
    return null;
  }
  Future<BarAiChat?> generateBarRecipeAI(String prompt) async {
    isLoading(true);
    final Map<String, dynamic> body = {"prompt": prompt, "language": "english"};

    try {
      final response = await CustomHttp.post(
        endpoint: ApiConstant.barAiChatBot,
        body: body,
        need_auth: true,
      );

      if (response.ok && response.data != null) {
        return BarAiChat.fromJson(response.data["data"]);
      }
    } finally {
      isLoading(false);
    }
    return null;
  }
}
