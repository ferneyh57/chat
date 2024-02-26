import 'package:chat/data/repository/user/user_repository.dart';
import 'package:chat/ui/pages/auth/cubit/auth_cubit.dart';
import 'package:chat/ui/pages/home/view/available_users_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatefulWidget {
  final String userUid;
  final void Function() onLogout;
  const HomePage({
    super.key,
    required this.userUid,
    required this.onLogout,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    GetIt.I<AuthCubit>().onInit(widget.userUid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('home'),
        actions: [
          IconButton(onPressed: widget.onLogout, icon: Icon(Icons.logout)),
        ],
      ),
      body: BlocBuilder<AuthCubit, AuthState>(
        bloc: GetIt.I<AuthCubit>(),
        builder: (context, state) {
          if (state.loading) {
            return const Center(
              child: SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (state.error != null) return Center(child: Text(state.error ?? 'error'));
          return UserWidget(
            getUsers: (doc) {
              return GetIt.I<UserRepository>().getAll(startAfter: doc);
            },
          );
        },
      ),
    );
  }
}
