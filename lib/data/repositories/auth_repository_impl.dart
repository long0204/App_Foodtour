// lib/data/repositories/auth_repository_impl.dart
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/local/secure_storage_datasource.dart';
import '../datasources/remote/auth_remote_datasource.dart';

/// Implementation of AuthRepository
/// Coordinates between remote and local data sources
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final SecureStorageDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<UserEntity> signInWithEmail(String email, String password) async {
    try {
      // Sign in with remote data source (Firebase)
      final user = await remoteDataSource.signInWithEmail(email, password);
      
      // Save token locally
      await localDataSource.saveToken(user.uid);
      await localDataSource.saveUserId(user.uid);
      
      // Convert Firebase User to UserEntity
      return _userToEntity(user);
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  @override
  Future<UserEntity> signUpWithEmail(String email, String password) async {
    try {
      final user = await remoteDataSource.signUpWithEmail(email, password);
      
      await localDataSource.saveToken(user.uid);
      await localDataSource.saveUserId(user.uid);
      
      return _userToEntity(user);
    } catch (e) {
      throw Exception('Sign up failed: $e');
    }
  }

  @override
  Future<UserEntity> signInWithGoogle() async {
    try {
      final user = await remoteDataSource.signInWithGoogle();
      
      if (user == null) {
        throw Exception('Google sign in cancelled');
      }
      
      await localDataSource.saveToken(user.uid);
      await localDataSource.saveUserId(user.uid);
      
      return _userToEntity(user);
    } catch (e) {
      throw Exception('Google sign in failed: $e');
    }
  }

  @override
  Future<UserEntity> signInWithApple() async {
    try {
      final user = await remoteDataSource.signInWithApple();
      
      if (user == null) {
        throw Exception('Apple sign in cancelled');
      }
      
      await localDataSource.saveToken(user.uid);
      await localDataSource.saveUserId(user.uid);
      
      return _userToEntity(user);
    } catch (e) {
      throw Exception('Apple sign in failed: $e');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await remoteDataSource.signOut();
      await localDataSource.clearAll();
    } catch (e) {
      throw Exception('Sign out failed: $e');
    }
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    try {
      final user = await remoteDataSource.getCurrentUser();
      
      if (user == null) return null;
      
      return _userToEntity(user);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      final token = await localDataSource.getToken();
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> updateProfile({String? displayName, String? photoUrl}) async {
    // TODO: Implement profile update
    throw UnimplementedError('TODO: Implement profile update');
  }

  /// Convert Firebase User to UserEntity
  UserEntity _userToEntity(User user) {
    return UserEntity(
      id: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      photoUrl: user.photoURL,
      createdAt: user.metadata.creationTime,
    );
  }
}
