import 'package:flowva/features/dashboard/profile/presentation/pages/profile_page.dart';
import 'package:flowva/features/onbaording/data/bloc/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FlowvaRoute {
  static UserCubit userCubit=UserCubit();

  static Map<String, Widget Function(BuildContext)> allRoutes = {

    ProfilePage.routeName: (_) => BlocProvider<UserCubit>.value( value: userCubit, child:  ProfilePage() ),

  };
}