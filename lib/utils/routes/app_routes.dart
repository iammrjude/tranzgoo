import 'package:flutter/material.dart';
import 'package:tranzgoo/presentation/view/auth_view/create_account_screen.dart';
import 'package:tranzgoo/presentation/view/auth_view/login_screen.dart';
import 'package:tranzgoo/presentation/view/auth_view/register_screen.dart';
import 'package:tranzgoo/presentation/view/auth_view/splash_screen.dart';
import 'package:tranzgoo/presentation/view/auth_view/welcome_screen.dart';
import 'package:tranzgoo/presentation/view/home_view/base_screen.dart';
import 'package:tranzgoo/presentation/view/home_view/fund_account.dart';
import 'package:tranzgoo/presentation/view/home_view/home_screen.dart';
import 'package:tranzgoo/presentation/view/home_view/send_screen.dart';

class AppRoutes {
  static const String splashView = '/splashView';
  static const String homeView = '/homeView';
  static const String registerView = '/registerView';
  static const String loginView = '/loginView';
  static const String welcomeView = '/welcomeView';
  static const String createAccountView = '/createAccountView';
  static const String baseView = '/baseView';
  static const String fundAccountView = '/fundAccountView';
  static const String sendView = '/sendView';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      AppRoutes.splashView: (_) => const SplashScreen(),
      AppRoutes.homeView: (_) => const HomeScreen(),
      AppRoutes.registerView: (_) => const RegisterScreen(),
      AppRoutes.loginView: (_) => const LoginScreen(),
      AppRoutes.welcomeView: (_) => const WelcomeScreen(),
      AppRoutes.createAccountView: (_) => const CreateAccountScreen(),
      AppRoutes.baseView: (_) => const BaseView(),
      AppRoutes.fundAccountView: (_) => const FundAccount(),
      AppRoutes.sendView:(_)=> const SendView(),
    };
  }
}
