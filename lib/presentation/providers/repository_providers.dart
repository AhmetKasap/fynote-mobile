import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/datasources/user_profile_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/user_profile_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/user_profile_repository.dart';
import 'core_providers.dart';

/// Auth Remote Data Source Provider
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return AuthRemoteDataSourceImpl(dio);
});

/// User Profile Remote Data Source Provider
final userProfileRemoteDataSourceProvider =
    Provider<UserProfileRemoteDataSource>((ref) {
      final dio = ref.watch(dioProvider);
      return UserProfileRemoteDataSourceImpl(dio);
    });

/// Auth Repository Provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
  final secureStorage = ref.watch(secureStorageProvider);
  return AuthRepositoryImpl(
    remoteDataSource: remoteDataSource,
    secureStorage: secureStorage,
  );
});

/// User Profile Repository Provider
final userProfileRepositoryProvider = Provider<UserProfileRepository>((ref) {
  final remoteDataSource = ref.watch(userProfileRemoteDataSourceProvider);
  return UserProfileRepositoryImpl(remoteDataSource: remoteDataSource);
});
