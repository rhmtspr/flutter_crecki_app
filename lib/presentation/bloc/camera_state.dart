part of 'camera_bloc.dart';

class CameraState {
  final String? imagePath;
  final XFile? imageFile;
  final CameraController? controller;
  final bool isInitialized;
  final String? error;

  const CameraState({
    this.imagePath,
    this.imageFile,
    this.controller,
    this.isInitialized = false,
    this.error,
  });

  CameraState copyWith({
    String? imagePath,
    XFile? imageFile,
    CameraController? controller,
    bool? isInitialized,
    String? error,
  }) {
    return CameraState(
      imagePath: imagePath ?? this.imagePath,
      imageFile: imageFile ?? this.imageFile,
      controller: controller ?? this.controller,
      isInitialized: isInitialized ?? this.isInitialized,
      error: error,
    );
  }
}
