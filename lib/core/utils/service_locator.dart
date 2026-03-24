import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../auth/data/repositories/auth_repository_impl.dart';
import '../../auth/domain/repositories/auth_repository.dart';
import '../../deals/data/datasources/deal_local_data_source.dart';
import '../../deals/data/datasources/deal_remote_data_source.dart';
import '../../deals/data/repositories/deal_repository_impl.dart';
import '../../deals/domain/repositories/deal_repository.dart';
import '../../auth/presentation/bloc/auth_bloc.dart';
import '../../deals/presentation/bloc/deal_list/deal_list_bloc.dart';

final sl = GetIt.instance; // sl stands for Service Locator

Future<void> init() async {
  // Features - BLoCs
  sl.registerFactory(() => AuthBloc(authRepository: sl()));
  sl.registerFactory(() => DealListBloc(repository: sl()));

  // Repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sharedPreferences: sl()));
  sl.registerLazySingleton<DealRepository>(() => DealRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()));

  // Data Sources
  sl.registerLazySingleton<DealRemoteDataSource>(() => DealRemoteDataSourceImpl());
  sl.registerLazySingleton<DealLocalDataSource>(() => DealLocalDataSourceImpl(sharedPreferences: sl()));

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}
