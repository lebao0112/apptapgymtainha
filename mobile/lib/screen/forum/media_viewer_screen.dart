import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class MediaViewerScreen extends StatefulWidget {
  final List<String> mediaUrls;
  final String username;

  const MediaViewerScreen({
    super.key,
    required this.mediaUrls,
    required this.username,
  });

  @override
  State<MediaViewerScreen> createState() => _MediaViewerState();
}

class _MediaViewerState extends State<MediaViewerScreen> {
  late String username = widget.username;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bài đăng của ${username.isNotEmpty ? username : "người dùng"}'),
      ),
      body: SafeArea(
        child: widget.mediaUrls.isEmpty
            ? Center(
          child: Text(
            'Không có hình ảnh nào để hiển thị.',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        )
            : ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: widget.mediaUrls.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                // Điều hướng đến màn hình zoom ảnh
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ImageZoomScreen(
                      mediaUrls: widget.mediaUrls,
                      initialIndex: index,
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    widget.mediaUrls[index],
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        height: 200,
                        child: Center(
                          child: Icon(
                            Icons.broken_image,
                            color: Colors.grey,
                            size: 40,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ImageZoomScreen extends StatelessWidget {
  final List<String> mediaUrls;
  final int initialIndex;

  const ImageZoomScreen({
    super.key,
    required this.mediaUrls,
    required this.initialIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Xem ảnh"),
      ),
      body: PhotoViewGallery.builder(
        itemCount: mediaUrls.length,
        pageController: PageController(initialPage: initialIndex),
        builder: (context, index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(mediaUrls[index]),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2.0,
            heroAttributes: PhotoViewHeroAttributes(tag: mediaUrls[index]),
          );
        },
        scrollPhysics: const BouncingScrollPhysics(),
        backgroundDecoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
      ),
    );
  }
}
