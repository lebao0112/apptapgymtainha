import 'package:flutter/material.dart';

class MediaViewerScreen extends StatefulWidget {
  const MediaViewerScreen({super.key});

  @override
  State<MediaViewerScreen> createState() => _MediaViewerState();
}

class _MediaViewerState extends State<MediaViewerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bài đăng của <username>'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),

            ),
          ],
        ),
      ),
    );
  }
}
