import 'package:dartz/dartz.dart';
import 'package:flowva/features/common/model/campaign_response.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeRepository {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<Either<String, CampaignResponse>> fetchCampaigns() async {
    try {
      var res = await supabase.from('campaigns').select();

      if (res != null) {
        CampaignResponse campaignResponse = CampaignResponse.fromJson({
          "campaign": res,
        });
        return Right(campaignResponse);
      } else {
        return Left("Invalid credentials");
      }
    } on AuthException catch (e) {
      return Left(e.message);
    }
  }
}
