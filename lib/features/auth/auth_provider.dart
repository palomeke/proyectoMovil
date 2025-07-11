import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(),
);

final authStateProvider = StreamProvider<User?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges;
});
