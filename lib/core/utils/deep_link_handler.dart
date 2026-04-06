import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/auth/presentation/widget/authentication_modal.dart';
import '../../utility/navigation.dart';
import '../constants/navigators/routeName.dart';
import 'pending_deep_link_handler.dart';
import 'pending_referral_code.dart';

class DeepLinkHandler {
  static const _authRequired = {'squad', 'mission', 'profile', 'redeem'};
  static const _publicRoutes = {'referral', 'reset-password'};

  static void handle(Uri uri) {
    debugPrint('DeepLink received: $uri');

    final pathSegments = uri.pathSegments;
    if (pathSegments.isEmpty) return;

    final rootPath = pathSegments[0];
    final isLoggedIn = Supabase.instance.client.auth.currentSession != null;

    if (_publicRoutes.contains(rootPath)) {
      _navigate(uri);
      return;
    }

    if (_authRequired.contains(rootPath)) {
      if (isLoggedIn) {
        _navigate(uri);
      } else {
        // Save link then show your auth bottom sheet
        PendingDeepLink.instance.save(uri);
        debugPrint('DeepLink saved — showing auth modal');
        _showAuthModal();
      }
      return;
    }

    debugPrint('DeepLink: unhandled path "$rootPath"');
  }

  // Shows the auth bottom sheet from anywhere using the navigator key
  static void _showAuthModal() {
    final context = navigatorKey.currentContext;
    if (context == null) return;

    // Small delay to let the nav stack be ready (important for cold starts)
    Future.delayed(const Duration(milliseconds: 400), () {
      authenticationModal(); // your existing function
    });
  }

  // Called after successful login/onboarding
  static void consumePendingLink() {
    final pending = PendingDeepLink.instance.consume();
    if (pending != null) {
      debugPrint('Consuming pending deep link: $pending');
      Future.delayed(const Duration(milliseconds: 300), () {
        _navigate(pending);
      });
    }
  }

  static void _navigate(Uri uri) {
    final pathSegments = uri.pathSegments;
    if (pathSegments.isEmpty) return;

    switch (pathSegments[0]) {
      case 'squad':
        navigatorKey.currentState?.pushNamed(RouteName.squadPage);
        break;

      case 'mission':
        // Optional: sub-routes like mission/adventures
        final sub = pathSegments.length > 1 ? pathSegments[1] : null;
        if (sub == 'adventures') {
          navigatorKey.currentState?.pushNamed(RouteName.missionAdventuresPage);
        } else if (sub == 'skillup') {
          navigatorKey.currentState?.pushNamed(RouteName.missionSKillUpPage);
        } else {
          navigatorKey.currentState?.pushNamed(RouteName.missionOverviewPage);
        }
        break;

      case 'redeem':
        final sub = pathSegments.length > 1 ? pathSegments[1] : null;
        if (sub == 'history') {
          navigatorKey.currentState?.pushNamed(RouteName.redeemHistoryPage);
        } else {
          navigatorKey.currentState?.pushNamed(RouteName.redeemPage);
        }
        break;

      case 'home':
        navigatorKey.currentState?.pushNamed(RouteName.homePage);
        break;

      case 'referral':
        // bravoo://referral?code=ABC123
        // Pre-fill referral code — open onboarding modal with code
        final code = uri.queryParameters['code'];
        if (code != null) {
          _openReferralOnboarding(code);
        }
        break;

      case 'reset-password':
        break;
    }
  }

  // Opens auth modal with referral code pre-filled
  static void _openReferralOnboarding(String code) {
    final context = navigatorKey.currentContext;
    if (context == null) return;

    Future.delayed(const Duration(milliseconds: 400), () {
      // Store code so ReferralCode page can read it on open
      PendingReferralCode.instance.save(code);
      authenticationModal();
    });
  }
}
