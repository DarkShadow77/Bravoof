import 'package:bravoo/features/dashboard/squad/data/model/response/squad_mission_model.dart';
import 'package:bravoo/features/dashboard/squad/data/model/response/squad_model.dart';
import 'package:dartz/dartz.dart';

abstract class SquadRepository {
  Future<Either<String, List<Squad>>> fetchSquads({String? squadId});

  Future<Either<String, String>> joinSquad({required String squadId});

  Future<Either<String, String>> leaveSquad({required String squadId});

  Future<Either<String, List<SquadMission>>> fetchSquadMissions({
    required String squadId,
  });

  Future<Either<String, String>> completeMission({
    required int missionId,
    required String userId,
    required String? image,
    required String text,
  });
}
