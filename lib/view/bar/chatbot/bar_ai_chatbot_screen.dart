import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:genius_ai/config/theme/app_colors.dart';
import 'package:intl/intl.dart';

class BarAiChatbotScreen extends StatefulWidget {
  const BarAiChatbotScreen({super.key});

  @override
  State<BarAiChatbotScreen> createState() => _BarAiChatbotScreenState();
}

class _BarAiChatbotScreenState extends State<BarAiChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Message> _messages = [];
  PlatformFile? _selectedFile;

  // Function to pick Excel files
  Future<void> _pickExcelFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
    );

    if (result != null) {
      setState(() {
        _selectedFile = result.files.first;
      });
    }
  }

  void _sendMessage() {
    if (_controller.text.trim().isEmpty && _selectedFile == null) return;

    setState(() {
      // Add User Message
      _messages.insert(
        0,
        Message(
          text: _controller.text,
          isUser: true,
          fileName: _selectedFile?.name,
          time: DateFormat('hh:mm a').format(DateTime.now()),
        ),
      );

      // Simulate AI Response
      _messages.insert(
        0,
        Message(
          text:
              "I've received your message${_selectedFile != null ? ' and the file ${_selectedFile!.name}' : ''}. How can I help with this?",
          isUser: false,
          time: DateFormat('hh:mm a').format(DateTime.now()),
        ),
      );

      _controller.clear();
      _selectedFile = null;
    });
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
            if (_selectedFile != null) _buildFilePreview(),

            _buildInputArea(),
          ],
        ),
      ),
    );
  }

  Widget _buildFilePreview() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.description, color: Colors.green),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _selectedFile!.name,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 20),
            onPressed: () => setState(() => _selectedFile = null),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      // color: Colors.white,
      child: SafeArea(
        child: Row(
          children: [
            GestureDetector(
              onTap: _pickExcelFile,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.border, width: 2),
                ),
                child: const Icon(
                  Icons.add,
                  color: AppColors.lightText,
                  size: 28,
                ),
              ),
            ),
            SizedBox(width: 8),
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
            GestureDetector(
              onTap: _sendMessage,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.border, width: 2),
                ),
                child: SvgPicture.asset(
                  "assets/icons/send.svg",
                  height: 28.w,
                  width: 28.w,
                  fit: BoxFit.cover,
                  colorFilter: const ColorFilter.mode(
                    AppColors.text,
                    BlendMode.srcIn,
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
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isUser ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 0),
            bottomRight: Radius.circular(isUser ? 0 : 16),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withValues(alpha: 0.25),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message.fileName != null) _buildFileAttachment(),
            if (message.text.isNotEmpty)
              Text(
                message.text,
                style: TextStyle(
                  color: isUser ? AppColors.surface : AppColors.text,
                  fontSize: 15,
                ),
              ),
            // const SizedBox(height: 4),
            // Text(
            //   message.time,
            //   style: TextStyle(
            //     color: isUser ? Colors.white70 : Colors.black45,
            //     fontSize: 10,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileAttachment() {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.table_chart,
            color: Colors.green,
            size: 28,
          ), // Excel Icon
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              message.fileName!,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
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
