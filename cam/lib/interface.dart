import 'dart:async';
import 'package:cam/DisplayPictureScreen.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraInterface extends StatefulWidget {
  @override
  _CameraInterfaceState createState() => _CameraInterfaceState();
}

class _CameraInterfaceState extends State<CameraInterface> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();

    // Initialize the camera controller
    _controller = CameraController(
      CameraDescription(
        name: '0',
        lensDirection: CameraLensDirection.back,
        sensorOrientation: 0,
      ),
      ResolutionPreset.medium,
    );

    // Initialize the camera controller asynchronously
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the camera controller when not needed
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera Interface'),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the camera preview
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        onPressed: () async {
          try {
            // Ensure the camera is initialized before taking a picture
            await _initializeControllerFuture;

            // Take the picture and get the image data
            final XFile image = await _controller.takePicture();

            // Navigate to a new screen to display the captured image
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    DisplayPictureScreen(imagePath: image.path),
              ),
            );
          } catch (e) {
            print('Error taking picture: $e');
          }
        },
      ),
    );
  }
}
