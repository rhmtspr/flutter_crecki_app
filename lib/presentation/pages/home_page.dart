import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cracky_app/presentation/bloc/camera_bloc.dart';
import 'package:flutter_cracky_app/presentation/bloc/crack_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_cracky_app/presentation/pages/camera_page.dart';

class HomePage extends StatelessWidget {
  static const routeName = "/home";

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: const Text("Crecki"),
        centerTitle: true,
        // elevation: 0,
        // backgroundColor: Colors.white,
        // foregroundColor: Colors.black87,
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<CameraBloc, CameraState>(
            listener: (context, state) {
              if (state.error != null) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.error!)));
              }
            },
          ),
          BlocListener<CrackDetectionBloc, CrackDetectionState>(
            listener: (context, state) {
              if (state is DetectionSuccess) {
                Navigator.pushNamed(
                  context,
                  "/result",
                  arguments: state.result,
                );
              }
              if (state is DetectionFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
        ],
        child: BlocBuilder<CameraBloc, CameraState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildImagePreview(state),

                  if (state.imageFile != null) ...[
                    const SizedBox(height: 16),
                    _PredictButton(imagePath: state.imageFile!.path),
                  ],

                  const SizedBox(height: 24),

                  Row(
                    children: [
                      Expanded(
                        child: _ActionButton(
                          onPressed: () => _onGalleryView(context),
                          icon: Icons.photo,
                          label: "Gallery",
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ActionButton(
                          onPressed: () => _onCameraView(context, state),
                          icon: Icons.camera_alt,
                          label: "Camera",
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildImagePreview(CameraState state) {
    return Container(
      width: double.infinity,
      height: 250,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(14),
      ),
      child: state.imageFile != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.file(File(state.imageFile!.path), fit: BoxFit.cover),
            )
          : const Center(
              child: Icon(Icons.image, size: 50, color: Colors.grey),
            ),
    );
  }

  Future<void> _onGalleryView(BuildContext context) async {
    if (kIsWeb ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.linux) {
      return;
    }

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null && context.mounted) {
      context.read<CameraBloc>().add(SetCameraImage(pickedFile));
    }
  }

  Future<void> _onCameraView(BuildContext context, CameraState state) async {
    final isMobile =
        defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;

    if (isMobile) {
      // Initialize the physical cameras
      final cameras = await availableCameras();
      if (context.mounted) {
        Navigator.pushNamed(context, CameraPage.routeName, arguments: cameras);
      }
    } else {
      // Fallback for Desktop/Web using ImagePicker
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null && context.mounted) {
        context.read<CameraBloc>().add(SetCameraImage(pickedFile));
      }
    }
  }
}

class _PredictButton extends StatelessWidget {
  final String imagePath;

  const _PredictButton({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CrackDetectionBloc, CrackDetectionState>(
      builder: (context, state) {
        if (state is DetectionLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return ElevatedButton(
          onPressed: () {
            context.read<CrackDetectionBloc>().add(
              OnImageCaptured(File(imagePath)),
            );
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: const Text("Predict"),
        );
      },
    );
  }
}

class _ActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String label;

  const _ActionButton({
    required this.onPressed,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        side: BorderSide(color: Colors.grey.shade300),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}
