import 'package:flutter/material.dart';

class ConfirmationDialog {


  static Future<bool> showConfirmationDialog(BuildContext context, String title, String content) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // Đóng và trả về false
              child: Text('Huỷ'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true), // Đóng và trả về true
              child: Text('Xoá'),
            ),
          ],
        );
      },
    ) ?? false; // Trả về false nếu dialog bị đóng mà không chọn
  }

}