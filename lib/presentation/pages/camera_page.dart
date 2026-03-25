import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cracky_app/core/utils/app_error_handler.dart';
import 'package:flutter_cracky_app/presentation/bloc/camera_bloc.dart';

class CameraPage extends StatefulWidget {
  static const routeName = "/camera";
  final List<CameraDescription> cameras;

  const CameraPage({super.key, required this.cameras});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> with WidgetsBindingObserver {
  late final CameraBloc _cameraBloc;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _cameraBloc = context.read<CameraBloc>();
    _cameraBloc.add(CameraInitialize(widget.cameras));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraBloc.add(CameraStopped());
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      _cameraBloc.add(CameraStopped());
    } else if (state == AppLifecycleState.resumed) {
      _cameraBloc.add(CameraResumed());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CameraBloc, CameraState>(
      listener: (context, state) {
        if (state.error != null) {
          // Assuming AppErrorHandler is available from the import
          AppErrorHandler.handleError(
            context: context,
            message: state.error!,
            error: Exception(state.error),
            name: 'CameraError',
          );
        }
        if (state.imageFile != null) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return Theme(
          data: ThemeData.dark(),
          child: Scaffold(
            appBar: AppBar(
              title: const Text("Ambil Gambar"),
              actions: [
                IconButton(
                  onPressed: () =>
                      context.read<CameraBloc>().add(CameraSwitch()),
                  icon: const Icon(Icons.cameraswitch),
                ),
              ],
            ),
            body: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  state.isInitialized && state.controller != null
                      ? CameraPreview(state.controller!)
                      : const Center(child: CircularProgressIndicator()),
                  Align(
                    alignment: const Alignment(0, 0.95),
                    child: _actionWidget(context),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _actionWidget(BuildContext context) {
    return FloatingActionButton(
      heroTag: "take-picture",
      tooltip: "Ambil Gambar",
      onPressed: () => context.read<CameraBloc>().add(CameraCapture()),
      child: const Icon(Icons.camera_alt),
    );
  }
}
