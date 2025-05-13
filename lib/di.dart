import 'package:babilon/core/application/repositories/auth_repository.dart';
import 'package:babilon/core/application/repositories/live_repository.dart';
import 'package:babilon/core/application/repositories/user_repository.dart';
import 'package:babilon/core/application/repositories/video_repository.dart';
import 'package:babilon/infrastructure/repositories/auth_repository.dart';
import 'package:babilon/infrastructure/repositories/live_repository.dart';
import 'package:babilon/infrastructure/repositories/user_repository.dart';
import 'package:babilon/infrastructure/repositories/video_repository.dart';
import 'package:babilon/infrastructure/services/socket_client.service.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'core/application/repositories/app_cubit/app_cubit.dart';
import 'di.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init', // default
  preferRelativeImports: true, // default
  asExtension: true, // default
)
Future<void> configureDependencies() async {
  getIt.init();
  // App cubit
  getIt.registerLazySingleton<AppCubit>(() => AppCubit());

  // repository
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
  getIt.registerLazySingleton<UserRepository>(() => UserRepositoryImpl());
  getIt.registerLazySingleton<VideoRepository>(() => VideoRepositoryImpl());
  getIt.registerLazySingleton<LiveRepository>(() => LiveRepositoryImpl());

  // service
  getIt.registerLazySingleton<SocketClientService>(() => SocketClientService());
}
