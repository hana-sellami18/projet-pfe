import 'package:get_it/get_it.dart';
import '../api/dio_client.dart';
import '../../features/auth/data/repositories/auth_repository.dart';
import '../../features/auth/logic/auth_bloc.dart';
import '../../features/internship/data/repositories/internship_repository.dart';
import '../../features/internship/logic/internship_bloc.dart';

// sl = Service Locator
final sl = GetIt.instance;

Future<void> initInjection() async {
  // 1. CLIENT API (Singleton)
  sl.registerLazySingleton<DioClient>(() => DioClient());

  // 2. REPOSITORIES (Singleton)

  // Auth
  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepository(sl<DioClient>()),
  );

  // Internship ✅ InternshipRepositoryImpl (pas la classe abstraite)
  sl.registerLazySingleton<InternshipRepository>(
        () => InternshipRepositoryImpl(sl<DioClient>()),
  );

  // 3. BLOCS (Factory — nouvelle instance à chaque fois)

  // Auth
  sl.registerFactory<AuthBloc>(
        () => AuthBloc(authRepository: sl<AuthRepository>()),
  );

  // Internship
  sl.registerFactory<InternshipBloc>(
        () => InternshipBloc(repository: sl<InternshipRepository>()),
  );
}