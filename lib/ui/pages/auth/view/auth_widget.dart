import 'package:chat/data/repository/repository.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class AuthWidget extends StatelessWidget {
  final AuthType type;
  const AuthWidget({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 500,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              TextButton(
                  onPressed: () async {
                    final authRepo = GetIt.I<AuthRepository>();
                    final (error, _) = type == AuthType.login
                        ? await authRepo.login(email: 'ferneyh57@gmail.com', password: 'mock12345')
                        : await authRepo.register(email: 'ferney4@gmail.com', password: 'mock12345');
                    if (error != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(error),
                        ),
                      );
                    }
                  },
                  child: const Text('Login'))
            ],
          ),
        ),
      ),
    );
  }
}

enum AuthType {
  register,
  login,
}
