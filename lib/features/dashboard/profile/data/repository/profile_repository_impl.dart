import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flowva/features/onbaording/data/model/user_profile.dart';
import 'package:flowva/session/session_manager.dart';
import 'package:path/path.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'profile_repository.dart';

class ProfileRepositoryImpl extends ProfileRepository {
  final supabase = Supabase.instance.client;

  Future<Either<String, UserProfile>> fetchUserProfile() async {
    try {
      final response = await supabase
          .from('user_profile')
          .select()
          .eq('user_id', SessionManager().userIdVal)
          .single();

      UserProfile userProfile = UserProfile.fromJson(response);

      SessionManager().pointsVal = userProfile.totalPoints ?? 0;
      SessionManager().jackpotVal = userProfile.spins ?? 0;
      return Right(userProfile);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, UserProfile>> updateProfile({
    required UserProfile profile,
    File? imageFile,
  }) async {
    try {
      String? imageUrl;

      // 🖼 Upload image ONLY if provided
      if (imageFile != null) {
        final fileName = basename(imageFile.path);

        await supabase.storage
            .from('test-avatar')
            .upload(
              fileName,
              imageFile,
              fileOptions: const FileOptions(upsert: true),
            );

        imageUrl = supabase.storage.from('test-avatar').getPublicUrl(fileName);
      }

      // 🧠 Merge new image URL if exists
      final updatedProfile = imageUrl != null
          ? profile.copyWith(profilePic: imageUrl)
          : profile;

      final res = await supabase
          .from('user_profile')
          .update(updatedProfile.toJson())
          .eq('user_id', SessionManager().userIdVal)
          .select()
          .single();

      final userProfile = UserProfile.fromJson(res);

      SessionManager().pointsVal = userProfile.totalPoints ?? 0;
      SessionManager().jackpotVal = userProfile.spins ?? 0;

      return Right(userProfile);
    } on AuthException catch (e) {
      return Left(e.message);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
