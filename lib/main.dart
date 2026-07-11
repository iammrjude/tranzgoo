import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tranzgoo/utils/routes/app_routes.dart';
import 'package:tranzgoo/utils/theme/app_colors.dart';
import 'package:tranzgoo/utils/theme/app_theme.dart';
import 'package:tranzgoo/utils/widget/responsive_layout.dart';

final ValueNotifier<String?> _activeRouteName = ValueNotifier<String?>(
  AppRoutes.splashView,
);

class _AppRouteObserver extends NavigatorObserver {
  void _setActiveRoute(Route<dynamic>? route) {
    _activeRouteName.value = route?.settings.name;
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _setActiveRoute(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _setActiveRoute(previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    _setActiveRoute(newRoute);
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 821),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.appTheme,
        navigatorObservers: [_AppRouteObserver()],
        builder: (context, child) {
          return ValueListenableBuilder<String?>(
            valueListenable: _activeRouteName,
            builder: (context, routeName, _) {
              final isSplashRoute = routeName == AppRoutes.splashView;

              return AppResponsiveFrame(
                backgroundColor: isSplashRoute ? AppColors.primaryColor : null,
                child: child ?? const SizedBox.shrink(),
              );
            },
          );
        },
        initialRoute: AppRoutes.splashView,
        routes: AppRoutes.getRoutes(),
      ),
    );
  }
}
