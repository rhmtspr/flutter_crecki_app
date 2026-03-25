import 'package:get_it/get_it.dart';
import 'package:flutter_cracky_app/data/datasources/ai_local_datasource.dart';
import 'package:flutter_cracky_app/data/repositories/crack_repository_impl.dart';
import 'package:flutter_cracky_app/domain/repositories/crack_repository.dart';
import 'package:flutter_cracky_app/domain/usecases/analyze_structural_damage.dart';
import 'package:flutter_cracky_app/presentation/bloc/camera_bloc.dart';
import 'package:flutter_cracky_app/presentation/bloc/crack_bloc.dart';

final locator = GetIt.instance;

Future<void> initInjection() async {
  // Bloc
  locator.registerFactory(() => CameraBloc());
  locator.registerFactory(() => CrackDetectionBloc(repository: locator()));

  // Use cases
  locator.registerLazySingleton(() => AnalyzeStructuralDamage(locator()));

  // Repository
  locator.registerLazySingleton<CrackRepository>(
    () => CrackRepositoryImpl(localDatasource: locator()),
  );

  // Data sources
  final aiLocalDatasource = AiLocalDatasource();
  await aiLocalDatasource.loadModel();
  locator.registerLazySingleton(() => aiLocalDatasource);
}
