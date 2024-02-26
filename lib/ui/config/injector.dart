import 'package:chat/data/datasource/datasource.dart';
import 'package:chat/data/repository/user/user_repository.dart';
import 'package:chat/ui/pages/auth/cubit/auth_cubit.dart';
import 'package:get_it/get_it.dart';

import '../../data/repository/repository.dart';

void setupLocator() {
  ///Datasource
  GetIt.I.registerLazySingleton(AuthDataSource.new);
  GetIt.I.registerLazySingleton(MessageDataSource.new);
  GetIt.I.registerLazySingleton(UserDataSource.new);

  ///Repository
  GetIt.I.registerLazySingleton(
    () => AuthRepository(
      authDataSource: GetIt.I<AuthDataSource>(),
    ),
  );

  GetIt.I.registerLazySingleton(
    () => UserRepository(
      userDataSource: GetIt.I<UserDataSource>(),
    ),
  );

  ///Cubit
  GetIt.I.registerLazySingleton(
    () => AuthCubit(
      authRepository: GetIt.I<AuthRepository>(),
      userRepository: GetIt.I<UserRepository>(),
    ),
  );
}
