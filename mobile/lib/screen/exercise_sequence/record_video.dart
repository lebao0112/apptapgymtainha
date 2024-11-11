import 'dart:io';//truy cập file  copy tạo đường dẫn tới file
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';//chức năng định dạng tên file
import 'package:permission_handler/permission_handler.dart';

class RecordVideoScreen extends StatefulWidget {
  @override
  _RecordVideoScreenState createState() => _RecordVideoScreenState();
}

class _RecordVideoScreenState extends State<RecordVideoScreen> {
  CameraController? _cameraController;
  bool _isRecording = false;
  late List<CameraDescription> _cameras;// Stores a list of available cameras on the device.
  int _selectedCameraIndex = 0; // Track the current camera (0 for back, 1 for front)
  Future<void> _checkPermissions() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }
  @override
  void initState() {
    super.initState();
    _checkPermissions();
    _initializeCamera();
  }
//this method retrieves available cameras, selects the one based on _selectedCameraIndex,
//and initializes it with high resolution. After initializing, it calls setState to update the UI.
  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    _cameraController = CameraController(
      _cameras[_selectedCameraIndex],
      ResolutionPreset.high,
    );
    await _cameraController?.initialize();
    setState(() {});
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    if (_cameraController != null && !_isRecording) {
      await _cameraController?.startVideoRecording();
      setState(() {
        _isRecording = true;
      });
    }
  }

  Future<void> _stopRecording() async {
    if (_cameraController != null && _isRecording) {
      try {
        XFile videoFile = await _cameraController!.stopVideoRecording();
        setState(() {
          _isRecording = false;
        });

        // Generate a timestamped filename
        String timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
        String filename = 'gymtainha_$timestamp.mp4';

        // Get the DCIM directory
        Directory? dcimDir = Directory('/storage/emulated/0/DCIM/apptapgymtainha');
        if (!dcimDir.existsSync()) {
          await dcimDir.create(recursive: true); // Create directory if it doesn't exist
        }
        final String newPath = '${dcimDir.path}/$filename';
        final File newFile = File(newPath);

        // Copy the video to DCIM/apptapgymtainha
        await File(videoFile.path).copy(newFile.path);

        print("Video recorded to: ${newFile.path}"); // Accessible path
      } catch (e) {
        print("Error stopping video recording: $e");
      }
    }
  }

  void _toggleCamera() {
    setState(() {
      // Switch between cameras
      _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras.length;
    });
    _initializeCamera(); // Reinitialize the camera with the selected index
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Record Video'),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Record Video'),
      ),
      body: Column(
        children: [
          Expanded(
            child: AspectRatio(
              aspectRatio: _cameraController!.value.aspectRatio,
              child: CameraPreview(_cameraController!),
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _isRecording ? _stopRecording : _startRecording,
                child: Text(_isRecording ? 'Stop Recording' : 'Start Recording'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: _isRecording ? null : _toggleCamera,
                child: Text('Switch Camera'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isRecording ? Colors.grey : null,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
