import 'package:flutter/material.dart';

class BarAiChatbotScreen extends StatefulWidget {
  const BarAiChatbotScreen({super.key});

  @override
  State<BarAiChatbotScreen> createState() => _BarAiChatbotScreenState();
}

class _BarAiChatbotScreenState extends State<BarAiChatbotScreen> {
  final List<ChatMessage> _messages = [
    ChatMessage(text: 'How to cook chicken fry?', isUser: true),
    ChatMessage(
      text: 'Sure! Here is a simple chicken fry recipe for you.',
      isUser: false,
    ),
    ChatMessage(
      text: 'Give me the ingredient list for this recipe',
      isUser: true,
    ),
    ChatMessage(
      text: 'ingredient.xlsx',
      isUser: false,
      isFile: true,
      fileName: 'ingredient.xlsx',
    ),
  ];

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
    });
    _controller.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scroll = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("Ai Chatbot Screen")));
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final bool isFile;
  final String? fileName;

  const ChatMessage({
    required this.text,
    required this.isUser,
    this.isFile = false,
    this.fileName,
  });
}
