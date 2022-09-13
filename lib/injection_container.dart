import 'package:ecommerce_app/features/auth/domain/usecases/login_signup_usecase.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repo_impl.dart';
import 'features/auth/domain/repositories/auth_repo.dart';
import 'features/auth/presentation/bloc/cubit/auth_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! ############################### External ###############################
  await Firebase.initializeApp();
  final firebaseAuth = FirebaseAuth.instance;
  sl.registerLazySingleton(() => firebaseAuth);

  //! ############################### Auth Feature. ###############################

  //? ################################# Bloc Or Cubit #################################
  
  sl.registerFactory(() => AuthCubit(loginSignupUsecase: sl()));

  //? ################################# Usecases #################################

  sl.registerLazySingleton(() => LoginSignupUsecase(authRepo: sl()));

  //? ################################# Repository #################################
  sl.registerLazySingleton<AuthRepo>(
      () => AuthRepoImpl(authRemoteDataSource: sl()));

  //? ################################# Datasources #################################
  sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(firebaseAuth: sl()));

  //! ############################### Core ###############################
}
