import 'package:flutter/material.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePostScreen> {
  final FocusNode _focusNode = FocusNode();
  bool _isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    // Listen to focus changes to detect keyboard visibility
    _focusNode.addListener(() {
      setState(() {
        _isKeyboardVisible = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ĐĂNG BÀI'),
        actions: [
          ElevatedButton(
              onPressed: () {

              },
              child: Text(
                'Đăng',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white
                )
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
              ),
          )

        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      maxLines: 100,
                      autofocus: true,
                      focusNode: _focusNode,
                      decoration: InputDecoration(
                        hintText: "Nội dung...",
                      ),
                    ),
                  ),
                ],
              ),
            ),

            if(_isKeyboardVisible)
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.image, color: Colors.blue),
                        tooltip: "Add Image",
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.videocam, color: Colors.red),
                        tooltip: "Add Video",
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.attach_file, color: Colors.green),
                        tooltip: "Add File",
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.insert_emoticon, color: Colors.orange),
                        tooltip: "Add Emoji",
                      ),
                    ],
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
