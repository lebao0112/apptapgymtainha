import 'package:doan_tapgymtainha/service/api_social_media.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePostScreen> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _contentController = TextEditingController();
  bool _isKeyboardVisible = false;
  final ImagePicker _picker = ImagePicker();
  List<XFile> _selectedImages = [];


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

  Future<void> _pickMultipleImages() async {
    try {
      final List<XFile>? images = await _picker.pickMultiImage(
        maxWidth: 800, // Optional: Resize image width
        maxHeight: 800, // Optional: Resize image height
        imageQuality: 80, // Optional: Compress image quality (1-100)
      );
      if (images != null) {
        setState(() {
          _selectedImages = images;
        });
      }
    } catch (e) {
      print("Error picking images: $e");
    }
  }

  void createPost() async {
    final content = _contentController.text;
    if (content.isEmpty && _selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Nội dung không được để trống.")),
      );
      return;
    } else{
      // Chuyển đổi từ XFile sang File
      final List<File> mediaFiles = _selectedImages.map((xfile) => File(xfile.path)).toList();

      try {
        final result = await ApiSocialMedia.createPost(
          content: content,
          mediaType: "image",
          files: mediaFiles
        );

        if(result){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Đăng bài thành công")),
          );
          Navigator.pop(context);
        }
      } catch (error) {
        print("Error creating post: $error");
        return;
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ĐĂNG BÀI'),
        actions: [
          ElevatedButton(
              onPressed: createPost,

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
                      controller: _contentController,
                      autofocus: true,
                      focusNode: _focusNode,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: "Nội dung...",
                          border: InputBorder.none,
                      ),
                    ),
                  ),

                  if(_selectedImages != null && _selectedImages!.isNotEmpty)
                    Container(
                      height: 1000,
                      child:
                          GridView.builder(
                        padding: const EdgeInsets.all(8.0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3, // Number of images per row
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                        ),
                        itemCount: _selectedImages!.length,
                        itemBuilder: (context, index) {
                          return Image.file(
                            File(_selectedImages![index].path),
                            fit: BoxFit.cover,
                          );
                        },
                      )
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
                        onPressed: () {
                          _pickMultipleImages();
                        },
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
