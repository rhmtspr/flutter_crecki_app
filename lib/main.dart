import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cracky_app/injection.dart';
import 'package:flutter_cracky_app/presentation/bloc/camera_bloc.dart';
import 'package:flutter_cracky_app/presentation/bloc/crack_bloc.dart';
import 'package:provider/provider.dart';

void main() {
  initInjection();

  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider(create: (_) => locator<CameraBloc>()),
        BlocProvider(create: (_) => locator<CrackDetectionBloc>()),
      ],
    );
  }
}
