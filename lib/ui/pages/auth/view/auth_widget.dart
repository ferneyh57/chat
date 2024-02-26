import 'package:chat/data/repository/repository.dart';
import 'package:chat/ui/pages/auth/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class AuthWidget extends StatefulWidget {
  final AuthType type;
  const AuthWidget({
    super.key,
    required this.type,
  });

  @override
  State<AuthWidget> createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
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
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _passController,
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
                    final actions = GetIt.I<AuthCubit>();
                    final error = widget.type == AuthType.login
                        ? await actions.onLogin(
                            email: _emailController.text,
                            password: _passController.text,
                          )
                        : await actions.onRegister(
                            email: _emailController.text,
                            password: _passController.text,
                          );

                    if (error != null && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(error),
                        ),
                      );
                    }
                  },
                  child: const Text('Send')),
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
