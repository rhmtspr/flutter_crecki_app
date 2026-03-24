import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cracky_app/core/utils/router_observer.dart';
import 'package:flutter_cracky_app/injection.dart';
import 'package:flutter_cracky_app/presentation/bloc/camera_bloc.dart';
import 'package:flutter_cracky_app/presentation/bloc/crack_bloc.dart';
import 'package:flutter_cracky_app/presentation/pages/camera_page.dart';
import 'package:flutter_cracky_app/presentation/pages/home_page.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
      child: MaterialApp(
        title: "Flutter Crecki App",
        home: HomePage(),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case "/home":
              return MaterialPageRoute(builder: (_) => HomePage());
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
