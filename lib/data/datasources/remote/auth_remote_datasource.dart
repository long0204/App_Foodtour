// lib/data/datasources/remote/auth_remote_datasource.dart
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/api/api_client.dart';

/// Remote data source for authentication
abstract class AuthRemoteDataSource {
  Future<User> signInWithEmail(String email, String password);
  Future<User> signUpWithEmail(String email, String password);
  Future<User?> signInWithGoogle();
  Future<User?> signInWithApple();
  Future<void> signOut();
  Future<User?> getCurrentUser();
}

/// Implementation using Firebase Auth
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthRemoteDataSourceImpl(this.apiClient);

  @override
  Future<User> signInWithEmail(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    
    if (credential.user == null) {
      throw Exception('Sign in failed');
    }
    
    return credential.user!;
  }

  @override
  Future<User> signUpWithEmail(String email, String password) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    
    if (credential.user == null) {
      throw Exception('Sign up failed');
    }
    
    return credential.user!;
  }

  @override
  Future<User?> signInWithGoogle() async {
    // TODO: Implement Google Sign In
    throw UnimplementedError('TODO: Implement Google Sign In');
  }

  @override
  Future<User?> signInWithApple() async {
    // TODO: Implement Apple Sign In
    throw UnimplementedError('TODO: Implement Apple Sign In');
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }

  @override
  Future<User?> getCurrentUser() async {
    return _auth.currentUser;
  }
}
