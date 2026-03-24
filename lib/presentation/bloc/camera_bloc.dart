import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'camera_event.dart';
part 'camera_state.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  List<CameraDescription> _cameras = [];
  CameraDescription? _selectedCamera;

  CameraBloc() : super(const CameraState()) {
    on<SetCameraImage>((event, emit) {
      emit(state.copyWith(imageFile: event.imageFile));
    });

    on<SetCameraPath>((event, emit) {
      emit(state.copyWith(imagePath: event.imagePath));
    });

    on<CameraInitialize>((event, emit) async {
      _cameras = event.cameras;
      if (_cameras.isEmpty) return;

      // Reset to first camera on initialization
      _selectedCamera = _cameras.first;

      // Clear previous image and controller when initializing
      await state.controller?.dispose();

      await _initializeController(_selectedCamera!, emit, clearImage: true);
    });

    on<CameraResumed>((event, emit) async {
      if (_selectedCamera != null) {
        await _initializeController(_selectedCamera!, emit);
      }
    });

    on<CameraSwitch>((event, emit) async {
      if (_cameras.length < 2 || _selectedCamera == null) return;

      final currentParam = _selectedCamera;
      final newIndex = _cameras.indexOf(currentParam!) == 0 ? 1 : 0;
      _selectedCamera = _cameras[newIndex];

      await _initializeController(_selectedCamera!, emit);
    });

    on<CameraCapture>((event, emit) async {
      final controller = state.controller;
      if (controller == null ||
          !controller.value.isInitialized ||
          controller.value.isTakingPicture) {
        return;
      }

      try {
        final image = await controller.takePicture();
        add(SetCameraImage(image));
      } catch (e) {
        emit(state.copyWith(error: e.toString()));
      }
    });

    on<CameraStopped>((event, emit) async {
      await state.controller?.dispose();
      emit(state.copyWith(controller: null, isInitialized: false));
    });
  }

  Future<void> _initializeController(
    CameraDescription cameraDescription,
    Emitter<CameraState> emit, {
    bool clearImage = false,
  }) async {
    final previousController = state.controller;
    final controller = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
    );

    if (previousController != null && previousController.value.isInitialized) {
      await previousController.dispose();
    }

    try {
      await controller.initialize();
      emit(
        CameraState(
          imagePath: state.imagePath,
          imageFile: clearImage ? null : state.imageFile,
          controller: controller,
          isInitialized: true,
          error: null,
        ),
      );
    } on CameraException catch (e) {
      emit(
        state.copyWith(error: 'Failed to initialize camera: ${e.description}'),
      );
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  @override
  Future<void> close() {
    state.controller?.dispose();
    return super.close();
  }
}
