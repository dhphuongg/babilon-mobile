import 'package:babilon/core/application/repositories/auth_repository.dart';
import 'package:babilon/core/application/repositories/user_repository.dart';
import 'package:babilon/infrastructure/repositories/auth_repository.dart';
import 'package:babilon/infrastructure/repositories/user_repository.dart';
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
}
