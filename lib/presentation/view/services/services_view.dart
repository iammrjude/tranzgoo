import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tranzgoo/utils/theme/app_colors.dart';
import 'package:tranzgoo/utils/theme/app_style.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({Key? key}) : super(key: key);

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  serviceContainer(Image.asset('assets/icons/phoneIcon.png'),
                      'Airtime', () => null),
                  serviceContainer(Image.asset('assets/icons/internet.png'),
                      'Data', () => null),
                  serviceContainer(
                      Image.asset(
                        'assets/icons/swap.png',
                      ),
                      'Airtime2Cash',
                      () => null)
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  serviceContainer(Image.asset('assets/icons/education.png'),
                      'Education', () => null),
                  serviceContainer(Image.asset('assets/icons/electricity.png'),
                      'Electricity', () => null),
                  serviceContainer(Image.asset('assets/icons/tv.png'),
                      'Cable TV', () => null)
                ],
              )
            ],
          ),
        ),
      ),
    );
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
