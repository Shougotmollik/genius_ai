import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:genius_ai/config/theme/app_colors.dart';
import 'package:genius_ai/controller/chatbot_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BarAiChatbotScreen extends StatefulWidget {
  const BarAiChatbotScreen({super.key});

  @override
  State<BarAiChatbotScreen> createState() => _BarAiChatbotScreenState();
}

class _BarAiChatbotScreenState extends State<BarAiChatbotScreen> {
  final ChatbotController controller = Get.find<ChatbotController>();
  final TextEditingController _controller = TextEditingController();
  final List<Message> _messages = [];

  void _sendMessage() async {
    final userText = _controller.text.trim();
    if (userText.isEmpty) return;

    setState(() {
      _messages.insert(
        0,
        Message(
          text: userText,
          isUser: true,
          time: DateFormat('hh:mm a').format(DateTime.now()),
        ),
      );
    });
    _controller.clear();

    final result = await controller.generateBarRecipeAI(userText);

    if (result != null) {
      setState(() {
        _messages.insert(
          0,
          Message(
            text: result.markdown ?? result.message ?? "No content",
            isUser: false,
            time: DateFormat('hh:mm a').format(DateTime.now()),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bar Chatbot"),
        backgroundColor: AppColors.surface,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _messages.isEmpty
                  ? _buildPlaceholder()
                  : ListView.builder(
                      reverse: true,
                      padding: const EdgeInsets.all(16),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) =>
                          ChatBubble(message: _messages[index]),
                    ),
            ),
            _buildInputArea(),
          ],
        ),
      ),
    );
  }

  // New Placeholder Widget
  Widget _buildPlaceholder() {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withOpacity(0.05),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.1),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.local_bar_rounded,
                  size: 64.sp,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                "SAGE Bar Strategist",
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.text,
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: 12.h),

              Text(
                "Crafting perfect pours and profitable bar programs. How can I assist your service tonight?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.lightText,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 32.h),

              Text(
                "TRY ASKING FOR:",
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary.withOpacity(0.7),
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 16.h),

              _buildQuickAction("🍸 Signature Gin Cocktail"),
              _buildQuickAction("🍷 Wine Pairing for Steak"),
              _buildQuickAction("📉 Reducing Beverage Waste"),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget for Quick Action buttons
  Widget _buildQuickAction(String label) {
    return GestureDetector(
      onTap: () {
        _controller.text = label;
        _sendMessage();
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.text,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 12.sp,
              color: AppColors.lightText,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.border, width: 2),
                ),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: "Type a message...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Obx(
              () => controller.isLoading.value
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : GestureDetector(
                      onTap: _sendMessage,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.border, width: 2),
                        ),
                        child: SvgPicture.asset(
                          "assets/icons/send.svg",
                          height: 24.w,
                          width: 24.w,
                          colorFilter: const ColorFilter.mode(
                            AppColors.text,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final Message message;
  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    bool isUser = message.isUser;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.85,
        ),
        decoration: BoxDecoration(
          color: isUser ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: isUser
            ? Text(message.text, style: const TextStyle(color: Colors.white))
            : Markdown(
                data: message.text,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                styleSheet: MarkdownStyleSheet(
                  p: TextStyle(color: AppColors.text, fontSize: 14.sp),
                  blockquoteDecoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: const Border(
                      left: BorderSide(color: Colors.amber, width: 4),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

// Keeping the Message class local or ensuring it matches your other screen
class Message {
  final String text;
  final bool isUser;
  final String? fileName;
  final String time;

  Message({
    required this.text,
    required this.isUser,
    this.fileName,
    required this.time,
  });
}
