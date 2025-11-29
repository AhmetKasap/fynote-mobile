import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/auth/login_usecase.dart';
import '../../domain/usecases/auth/logout_usecase.dart';
import '../../domain/usecases/auth/register_usecase.dart';
import '../../domain/usecases/auth/verify_email_usecase.dart';
import '../../domain/usecases/user_profile/forgot_password_usecase.dart';
import '../../domain/usecases/user_profile/get_user_profile_usecase.dart';
import '../../domain/usecases/user_profile/reset_password_usecase.dart';
import '../../domain/usecases/user_profile/update_user_profile_usecase.dart';
import '../../domain/usecases/icon/get_icons_usecase.dart';
import '../../domain/usecases/folder/get_folders_usecase.dart';
import '../../domain/usecases/folder/get_folder_usecase.dart';
import '../../domain/usecases/folder/create_folder_usecase.dart';
import '../../domain/usecases/folder/update_folder_usecase.dart';
import '../../domain/usecases/folder/delete_folder_usecase.dart';
import '../../domain/usecases/note/get_notes_usecase.dart';
import '../../domain/usecases/note/get_note_usecase.dart';
import '../../domain/usecases/note/create_note_usecase.dart';
import '../../domain/usecases/note/update_note_usecase.dart';
import '../../domain/usecases/note/delete_note_usecase.dart';
import '../../domain/usecases/program/get_programs.dart';
import '../../domain/usecases/program/get_program_by_id.dart';
import '../../domain/usecases/program/create_program_from_text.dart';
import '../../domain/usecases/program/create_program_from_audio.dart';
import '../../domain/usecases/program/delete_program.dart';
import 'repository_providers.dart';

// ==================== Auth Use Cases ====================

final registerUseCaseProvider = Provider<RegisterUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return RegisterUseCase(repository);
});

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LoginUseCase(repository);
});

final verifyEmailUseCaseProvider = Provider<VerifyEmailUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return VerifyEmailUseCase(repository);
});

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LogoutUseCase(repository);
});

// ==================== User Profile Use Cases ====================

final getUserProfileUseCaseProvider = Provider<GetUserProfileUseCase>((ref) {
  final repository = ref.watch(userProfileRepositoryProvider);
  return GetUserProfileUseCase(repository);
});

final updateUserProfileUseCaseProvider = Provider<UpdateUserProfileUseCase>((
  ref,
) {
  final repository = ref.watch(userProfileRepositoryProvider);
  return UpdateUserProfileUseCase(repository);
});

final forgotPasswordUseCaseProvider = Provider<ForgotPasswordUseCase>((ref) {
  final repository = ref.watch(userProfileRepositoryProvider);
  return ForgotPasswordUseCase(repository);
});

final resetPasswordUseCaseProvider = Provider<ResetPasswordUseCase>((ref) {
  final repository = ref.watch(userProfileRepositoryProvider);
  return ResetPasswordUseCase(repository);
});

// ==================== Icon Use Cases ====================

final getIconsUseCaseProvider = Provider<GetIconsUseCase>((ref) {
  final repository = ref.watch(iconRepositoryProvider);
  return GetIconsUseCase(repository);
});

// ==================== Folder Use Cases ====================

final getFoldersUseCaseProvider = Provider<GetFoldersUseCase>((ref) {
  final repository = ref.watch(folderRepositoryProvider);
  return GetFoldersUseCase(repository);
});

final getFolderUseCaseProvider = Provider<GetFolderUseCase>((ref) {
  final repository = ref.watch(folderRepositoryProvider);
  return GetFolderUseCase(repository);
});

final createFolderUseCaseProvider = Provider<CreateFolderUseCase>((ref) {
  final repository = ref.watch(folderRepositoryProvider);
  return CreateFolderUseCase(repository);
});

final updateFolderUseCaseProvider = Provider<UpdateFolderUseCase>((ref) {
  final repository = ref.watch(folderRepositoryProvider);
  return UpdateFolderUseCase(repository);
});

final deleteFolderUseCaseProvider = Provider<DeleteFolderUseCase>((ref) {
  final repository = ref.watch(folderRepositoryProvider);
  return DeleteFolderUseCase(repository);
});

// ==================== Note Use Cases ====================

final getNotesUseCaseProvider = Provider<GetNotesUseCase>((ref) {
  final repository = ref.watch(noteRepositoryProvider);
  return GetNotesUseCase(repository);
});

final getNoteUseCaseProvider = Provider<GetNoteUseCase>((ref) {
  final repository = ref.watch(noteRepositoryProvider);
  return GetNoteUseCase(repository);
});

final createNoteUseCaseProvider = Provider<CreateNoteUseCase>((ref) {
  final repository = ref.watch(noteRepositoryProvider);
  return CreateNoteUseCase(repository);
});

final updateNoteUseCaseProvider = Provider<UpdateNoteUseCase>((ref) {
  final repository = ref.watch(noteRepositoryProvider);
  return UpdateNoteUseCase(repository);
});

final deleteNoteUseCaseProvider = Provider<DeleteNoteUseCase>((ref) {
  final repository = ref.watch(noteRepositoryProvider);
  return DeleteNoteUseCase(repository);
});

// ==================== Program Use Cases ====================

final getProgramsUseCaseProvider = Provider<GetPrograms>((ref) {
  final repository = ref.watch(programRepositoryProvider);
  return GetPrograms(repository);
});

final getProgramByIdUseCaseProvider = Provider<GetProgramById>((ref) {
  final repository = ref.watch(programRepositoryProvider);
  return GetProgramById(repository);
});

final createProgramFromTextUseCaseProvider = Provider<CreateProgramFromText>((
  ref,
) {
  final repository = ref.watch(programRepositoryProvider);
  return CreateProgramFromText(repository);
});

final createProgramFromAudioUseCaseProvider = Provider<CreateProgramFromAudio>((
  ref,
) {
  final repository = ref.watch(programRepositoryProvider);
  return CreateProgramFromAudio(repository);
});

final deleteProgramUseCaseProvider = Provider<DeleteProgram>((ref) {
  final repository = ref.watch(programRepositoryProvider);
  return DeleteProgram(repository);
});
