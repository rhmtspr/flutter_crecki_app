part of 'camera_bloc.dart';

abstract class CameraEvent {}

class CameraInitialize extends CameraEvent {
  final List<CameraDescription> cameras;
  CameraInitialize(this.cameras);
}

class CameraResumed extends CameraEvent {}

class CameraSwitch extends CameraEvent {}

class CameraCapture extends CameraEvent {}

class CameraStopped extends CameraEvent {}

class SetCameraImage extends CameraEvent {
  final XFile? imageFile;
  SetCameraImage(this.imageFile);
}

class SetCameraPath extends CameraEvent {
  final String? imagePath;
  SetCameraPath(this.imagePath);
}
