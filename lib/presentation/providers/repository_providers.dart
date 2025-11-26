import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/datasources/user_profile_remote_data_source.dart';
import '../../data/datasources/icon_remote_data_source.dart';
import '../../data/datasources/folder_remote_data_source.dart';
import '../../data/datasources/note_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/user_profile_repository_impl.dart';
import '../../data/repositories/icon_repository_impl.dart';
import '../../data/repositories/folder_repository_impl.dart';
import '../../data/repositories/note_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/user_profile_repository.dart';
import '../../domain/repositories/icon_repository.dart';
import '../../domain/repositories/folder_repository.dart';
import '../../domain/repositories/note_repository.dart';
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

/// Icon Remote Data Source Provider
final iconRemoteDataSourceProvider = Provider<IconRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return IconRemoteDataSourceImpl(dio);
});

/// Folder Remote Data Source Provider
final folderRemoteDataSourceProvider = Provider<FolderRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return FolderRemoteDataSourceImpl(dio);
});

/// Note Remote Data Source Provider
final noteRemoteDataSourceProvider = Provider<NoteRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return NoteRemoteDataSourceImpl(dio);
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

/// Icon Repository Provider
final iconRepositoryProvider = Provider<IconRepository>((ref) {
  final remoteDataSource = ref.watch(iconRemoteDataSourceProvider);
  return IconRepositoryImpl(remoteDataSource: remoteDataSource);
});

/// Folder Repository Provider
final folderRepositoryProvider = Provider<FolderRepository>((ref) {
  final remoteDataSource = ref.watch(folderRemoteDataSourceProvider);
  return FolderRepositoryImpl(remoteDataSource: remoteDataSource);
});

/// Note Repository Provider
final noteRepositoryProvider = Provider<NoteRepository>((ref) {
  final remoteDataSource = ref.watch(noteRemoteDataSourceProvider);
  return NoteRepositoryImpl(remoteDataSource: remoteDataSource);
});
