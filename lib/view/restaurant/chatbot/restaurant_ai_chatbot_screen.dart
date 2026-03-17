import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:genius_ai/config/theme/app_colors.dart';
import 'package:genius_ai/controller/chatbot_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RestaurantAiChatbotScreen extends StatefulWidget {
  const RestaurantAiChatbotScreen({super.key});

  @override
  State<RestaurantAiChatbotScreen> createState() =>
      _RestaurantAiChatbotScreenState();
}

class _RestaurantAiChatbotScreenState extends State<RestaurantAiChatbotScreen> {
  final ChatbotController controller = Get.find<ChatbotController>();

  final TextEditingController _controller = TextEditingController();
  final List<Message> _messages = [];
  PlatformFile? _selectedFile;

  // // Function to pick Excel files
  // Future<void> _pickExcelFile() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     type: FileType.custom,
  //     allowedExtensions: [
  //       'xlsx',
  //       'xls',
  //       'csv',
  //       "pdf",
  //       "doc",
  //       "docx",
  //       "jpg",
  //       "png",
  //       "jpeg",
  //     ],
  //   );

  //   if (result != null) {
  //     setState(() {
  //       _selectedFile = result.files.first;
  //     });
  //   }
  // }

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

    final result = await controller.generateRecipeAI(userText);

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
        title: const Text("AI Chatbot"),
        backgroundColor: AppColors.surface,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                reverse: true,
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) =>
                    ChatBubble(message: _messages[index]),
              ),
            ),

            // File Preview Area (Visible only when a file is selected)
            // if (_selectedFile != null) _buildFilePreview(),
            _buildInputArea(),
          ],
        ),
      ),
    );
  }

  // Widget _buildFilePreview() {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  //     margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
  //     decoration: BoxDecoration(
  //       color: Colors.green.withOpacity(0.1),
  //       borderRadius: BorderRadius.circular(12),
  //       border: Border.all(color: Colors.green.withOpacity(0.3)),
  //     ),
  //     child: Row(
  //       children: [
  //         const Icon(Icons.description, color: Colors.green),
  //         const SizedBox(width: 10),
  //         Expanded(
  //           child: Text(
  //             _selectedFile!.name,
  //             overflow: TextOverflow.ellipsis,
  //             style: const TextStyle(fontWeight: FontWeight.w500),
  //           ),
  //         ),
  //         IconButton(
  //           icon: const Icon(Icons.close, size: 20),
  //           onPressed: () => setState(() => _selectedFile = null),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      // color: Colors.white,
      child: SafeArea(
        child: Row(
          children: [
            // GestureDetector(
            //   onTap: _pickExcelFile,
            //   child: Container(
            //     padding: const EdgeInsets.all(8),
            //     decoration: BoxDecoration(
            //       shape: BoxShape.circle,
            //       border: Border.all(color: AppColors.border, width: 2),
            //     ),
            //     child: const Icon(
            //       Icons.add,
            //       color: AppColors.lightText,
            //       size: 28,
            //     ),
            //   ),
            // ),
            // SizedBox(width: 8),
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
            // CircleAvatar(
            //   backgroundColor: Colors.blueAccent,
            //   child: IconButton(
            //     icon: const Icon(Icons.send, color: Colors.white, size: 20),
            //     onPressed: _sendMessage,
            //   ),
            // ),
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
                    color: Colors.amber.withValues(alpha: 0.1),
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
