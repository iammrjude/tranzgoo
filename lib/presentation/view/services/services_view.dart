import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tranzgoo/data/services/api_exception.dart';
import 'package:tranzgoo/data/services/tranzgoo_api_service.dart';
import 'package:tranzgoo/utils/routes/app_routes.dart';
import 'package:tranzgoo/utils/theme/app_colors.dart';
import 'package:tranzgoo/utils/theme/app_style.dart';
import 'package:tranzgoo/utils/widget/app_state_widgets.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({Key? key}) : super(key: key);

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  final TranzgooApiService _apiService = TranzgooApiService();
  List<Map<String, dynamic>> services = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadServices();
  }

  Future<void> loadServices() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final data = await _apiService.getServices();

      if (!mounted) {
        return;
      }

      setState(() {
        services = data;
      });
    } on ApiException catch (error) {
      setState(() {
        errorMessage = error.message;
      });
    } catch (_) {
      setState(() {
        errorMessage = 'Unable to load services.';
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Services',
                style: AppText.extraBold
                    .copyWith(fontSize: 16, letterSpacing: 0.09),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text('Explore our range of services'),
              const SizedBox(
                height: 13,
              ),
              if (isLoading)
                const Expanded(child: AppLoadingState())
              else if (errorMessage != null)
                Expanded(
                  child: AppErrorState(
                    message: errorMessage!,
                    onRetry: loadServices,
                  ),
                )
              else
                Wrap(
                  spacing: 14.w,
                  runSpacing: 20,
                  children: serviceTiles(context),
                ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> serviceTiles(BuildContext context) {
    final knownServices = services.isEmpty
        ? [
            {'id': 'airtime', 'name': 'Airtime'},
            {'id': 'data', 'name': 'Data'},
            {'id': 'airtime-to-cash', 'name': 'Airtime2Cash'},
            {'id': 'education', 'name': 'Education'},
            {'id': 'electricity', 'name': 'Electricity'},
            {'id': 'cable', 'name': 'Cable TV'},
          ]
        : services;

    return knownServices.map((service) {
      final id = service['id']?.toString() ?? '';
      final name = service['name']?.toString() ?? '';
      return serviceContainer(
        serviceIcon(id),
        name,
        () => openService(context, id),
      );
    }).toList();
  }

  Widget serviceIcon(String id) {
    final icons = {
      'airtime': 'assets/icons/phoneIcon.png',
      'data': 'assets/icons/internet.png',
      'airtime-to-cash': 'assets/icons/swap.png',
      'education': 'assets/icons/education.png',
      'electricity': 'assets/icons/electricity.png',
      'cable': 'assets/icons/tv.png',
    };

    return Image.asset(icons[id] ?? 'assets/icons/service.png');
  }

  void openService(BuildContext context, String id) {
    final routes = {
      'airtime': AppRoutes.airtimeView,
      'data': AppRoutes.dataView,
      'airtime-to-cash': AppRoutes.airtimeToCashView,
      'education': AppRoutes.educationView,
      'electricity': AppRoutes.electricityView,
      'cable': AppRoutes.cableView,
    };
    final route = routes[id];

    if (route == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This service is not available yet.')),
      );
      return;
    }

    Navigator.pushNamed(context, route);
  }
}

Widget serviceContainer(Widget widget, String text, Function() onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: 96.h,
      width: 96.w,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: AppColors.whiteColor,
          border: Border.all(color: AppColors.grey200)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          widget,
          const SizedBox(
            height: 8,
          ),
          Text(
            text,
            style: AppText.extraBold
                .copyWith(color: AppColors.primaryColor, letterSpacing: 0.09),
          ),
        ],
      ),
    ),
  );
}
