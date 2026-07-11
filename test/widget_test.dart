import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tranzgoo/presentation/view/auth_view/forgot_password_screen.dart';
import 'package:tranzgoo/presentation/view/auth_view/login_screen.dart';
import 'package:tranzgoo/presentation/view/auth_view/register_screen.dart';

Future<void> pumpAuthScreen(WidgetTester tester, Widget child) async {
  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(375, 821),
      child: MaterialApp(home: child),
    ),
  );
  await tester.pump();
}

void main() {
  testWidgets('renders login screen fields and button', (
    WidgetTester tester,
  ) async {
    await pumpAuthScreen(tester, const LoginScreen());

    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Login'), findsWidgets);
  });

  testWidgets('renders register screen fields and submit button', (
    WidgetTester tester,
  ) async {
    await pumpAuthScreen(tester, const RegisterScreen());

    expect(find.text('Register'), findsOneWidget);
    expect(find.text('Full Name'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Phone'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Confirm Password'), findsOneWidget);
    expect(find.text('Submit'), findsOneWidget);
  });

  testWidgets('renders forgot password email request step', (
    WidgetTester tester,
  ) async {
    await pumpAuthScreen(tester, const ForgotPasswordScreen());

    expect(find.text('Forgot Password'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Send Reset Code'), findsOneWidget);
  });
}
