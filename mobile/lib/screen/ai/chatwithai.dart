import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class ChatWithAI extends StatefulWidget {
  const ChatWithAI({Key? key}) : super(key: key);

  @override
  State<ChatWithAI> createState() => _ChatWithAIState();
}

class _ChatWithAIState extends State<ChatWithAI> {
  final TextEditingController _textController = TextEditingController();
  final List<Map<String, String>> _messages = []; // Lưu tin nhắn với cấu trúc {role: "user"/"ai", message: "content"}
  bool _isLoading = false;

  Future<String> translateTextWithOpenAI(String inputText) async {
    try {
      final chatCompletion = await OpenAI.instance.chat.create(
        model: "gpt-3.5-turbo",
        messages: [
          OpenAIChatCompletionChoiceMessageModel(
            role: OpenAIChatMessageRole.system,
            content: "You are a professional gym coach. Provide expert advice and motivation for users based on their fitness goals and questions.",
          ),
          OpenAIChatCompletionChoiceMessageModel(
            role: OpenAIChatMessageRole.user,
            content: inputText,
          ),
        ],
      );
      return chatCompletion.choices.first.message.content.trim();
    } catch (e) {
      print("Error chatting with AI: $e");
      return "Xin lỗi, tôi không thể trả lời ngay bây giờ.";
    }
  }

  Future<void> _sendMessage() async {
    if (_textController.text.trim().isEmpty) return;

    setState(() {
      _messages.add({"role": "user", "message": _textController.text.trim()});
      _isLoading = true;
    });

    try {
      final aiResponse = await translateTextWithOpenAI(
        _textController.text.trim(),
      ); // Hàm này sẽ gọi OpenAI API
      setState(() {
        _messages.add({"role": "ai", "message": aiResponse});
      });
    } catch (error) {
      setState(() {
        _messages.add({
          "role": "ai",
          "message": "Xin lỗi, tôi không thể trả lời ngay bây giờ. Vui lòng thử lại sau."
        });
      });
    } finally {
      setState(() {
        _isLoading = false;
        _textController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Trò chuyện với HLV AI",
          style: GoogleFonts.audiowide(color: Colors.white),
        ),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message["role"] == "user";
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment:
                    isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                    children: [
                      if (!isUser)
                        CircleAvatar(
                          backgroundColor: Colors.orange,
                          child: Icon(Icons.fitness_center, color: Colors.white),
                        ),
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: isUser ? Colors.blueAccent : Colors.grey[800],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            message["message"] ?? "",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: CircularProgressIndicator(color: Colors.orange),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: "Nhập câu hỏi của bạn...",
                      hintStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey[900],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.orange),
                  onPressed: _isLoading ? null : _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
