import 'package:chat/data/repository/repository.dart';
import 'package:chat/ui/pages/auth/view/auth_page.dart';
import 'package:chat/ui/pages/home/view/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepo = GetIt.I<AuthRepository>();
    return StreamBuilder(
      stream: authRepo.getUserStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (snapshot.data != null) {
          return HomePage(
            userUid: authRepo.getCurrentAuthUser()?.uid ?? '',
            onLogout: authRepo.logout,
          );
        }
        return const AuthPage();
      },
    );
  }
}
