import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cracky_app/core/theme/app_theme.dart';
import 'package:flutter_cracky_app/core/utils/router_observer.dart';
import 'package:flutter_cracky_app/injection.dart';
import 'package:flutter_cracky_app/presentation/bloc/camera_bloc.dart';
import 'package:flutter_cracky_app/presentation/bloc/crack_bloc.dart';
import 'package:flutter_cracky_app/presentation/pages/camera_page.dart';
import 'package:flutter_cracky_app/presentation/pages/home_page.dart';
import 'package:flutter_cracky_app/presentation/pages/result_page.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initInjection();
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
      child: MaterialApp(
        title: "Flutter Crecki App",
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: HomePage(),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case "/home":
              return MaterialPageRoute(builder: (_) => HomePage());
            case "/camera":
              final cameras = settings.arguments as List<CameraDescription>;
              return MaterialPageRoute(
                builder: (_) => CameraPage(cameras: cameras),
              );
            case "/result":
              return MaterialPageRoute(
                builder: (_) => ResultPage(),
                settings: settings,
              );
            default:
              return MaterialPageRoute(
                builder: (_) {
                  return Scaffold(
                    body: Center(child: Text("Page not found :(")),
                  );
                },
              );
          }
        },
      ),
    );
  }
}
