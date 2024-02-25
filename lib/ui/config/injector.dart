import 'package:chat/data/datasource/datasource.dart';
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
      userDataSource: GetIt.I<UserDataSource>(),
    ),
  );
}
