import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_app/business_logic/phone_auth/phone_auth_cubit.dart';
import 'package:flutter_maps_app/core/utils/text_manager.dart';
import 'package:flutter_maps_app/presentation/screens/login_screen.dart';
import 'package:flutter_maps_app/presentation/screens/otp_screen.dart';

import '../presentation/screens/map_screen.dart';

class AppRouter {
  PhoneAuthCubit? phoneAuthCubit;

  AppRouter() {
    phoneAuthCubit = PhoneAuthCubit();
  }

  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case TextManager.mapScreen:
        return MaterialPageRoute(builder: (_) {
          return const MapScreen();
        });

      case TextManager.loginScreen:
        return MaterialPageRoute(builder: (_) {
          return BlocProvider<PhoneAuthCubit>.value(
              value: phoneAuthCubit!, child: LoginScreen());
        });

      case TextManager.otpScreen:
        final phoneNumber = settings.arguments;
        return MaterialPageRoute(builder: (_) {
          return BlocProvider<PhoneAuthCubit>.value(
              value: phoneAuthCubit!,
              child: OtpScreen(
                phoneNumber: phoneNumber,
              ));
        });
    }
  }
}
