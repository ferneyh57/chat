// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:chat/data/model/chat_user.dart';
import 'package:chat/data/repository/repository.dart';
import 'package:chat/data/repository/user/user_repository.dart';
import 'package:flutter/material.dart';

class AuthState {
  final ChatUser? chatUser;
  final bool loading;
  final String? error;
  AuthState({
    this.chatUser,
    required this.loading,
    this.error,
  });

  AuthState copyWith({
    ChatUser? chatUser,
    bool? loading,
    String? error,
  }) {
    return AuthState(
      chatUser: chatUser ?? this.chatUser,
      loading: loading ?? this.loading,
      error: error ?? this.error,
    );
  }
}

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;
  final UserRepository userRepository;
  AuthCubit({
    required this.authRepository,
    required this.userRepository,
  }) : super(AuthState(loading: true));

  Future<void> onInit(String uid) async {
    final (error, user) = await userRepository.getByUid(uid);
    if (error != null) {
      emit(
        state.copyWith(
          error: error,
          loading: false,
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        chatUser: user,
        loading: false,
      ),
    );
  }

  void sendError(String error) {
    emit(
      state.copyWith(
        error: error,
        loading: false,
      ),
    );
  }

  Future<String?> onLogin({
    required String email,
    required String password,
  }) async {
    final (authError, user) = await authRepository.login(email: email, password: password);
    if (authError != null) {
      return authError;
    }
    final (getUserError, chatUser) = await userRepository.getByUid(user?.uid ?? '');
    if (getUserError != null) {
      return getUserError;
    }
    emit(
      state.copyWith(
        chatUser: chatUser,
        loading: false,
      ),
    );
    return null;
  }

  Future<String?> onRegister({
    required String email,
    required String password,
  }) async {
    final (authError, user) = await authRepository.register(email: email, password: password);
    if (authError != null) {
      return authError;
    }
    final (getUserError, chatUser) = await userRepository.create(
      user?.uid ?? '',
      ChatUser(
        email: user?.email,
        lastSeen: DateTime.now().millisecondsSinceEpoch,
        uid: user?.uid,
      ),
    );
    if (getUserError != null) {
      return getUserError;
    }
    emit(
      state.copyWith(
        chatUser: chatUser,
        loading: false,
      ),
    );
    return null;
  }

  Future<void> onLogout() async {}
}
