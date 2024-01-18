import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tranzgoo/presentation/view/home_view/component/account_card.dart';
import 'package:tranzgoo/presentation/view/home_view/component/carousel_slider.dart';
import 'package:tranzgoo/presentation/view/home_view/component/history_component.dart';
import 'package:tranzgoo/utils/theme/app_colors.dart';
import 'package:tranzgoo/utils/theme/app_style.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 20, 28, 0),
          child: SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(48),
                          child: Image.asset('assets/images/person.png'),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Good morning',
                                  style: AppText.extraBold.copyWith(
                                      fontSize: 16, letterSpacing: 0.092),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Image.asset('assets/icons/Group 9.png'),
                              ],
                            ),
                            Text(
                              'John Doe',
                              style: AppText.mediumStyle
                                  .copyWith(fontSize: 16, letterSpacing: 0.092),
                            ),
                            Text(
                              'A200231',
                              style: AppText.lightStyle.copyWith(
                                  color: AppColors.grey500,
                                  letterSpacing: 0.092,
                                  fontSize: 10),
                            )
                          ],
                        ),
                      ],
                    ),
                    Container(
                      height: 23.h,
                      width: 23.w,
                      decoration: BoxDecoration(
                          border: Border.all(color: AppColors.primaryColor),
                          borderRadius: BorderRadius.circular(6),
                          color: AppColors.whiteColor),
                      child: Image.asset('assets/icons/notification.png'),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const AccountCard(),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Image.asset('assets/icons/bolt.png'),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Quick Access',
                      style: AppText.extraBold.copyWith(
                          color: AppColors.primaryColor, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 13.5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    quickAccessContainer(
                        icon: Image.asset(
                          'assets/icons/phoneIcon.png',
                          height: 16,
                          width: 16,
                          color: AppColors.primaryColor,
                        ),
                        text: 'Airtime'),
                    quickAccessContainer(
                        icon: Image.asset(
                          'assets/icons/search.png',
                          color: AppColors.primaryColor,
                        ),
                        text: 'Data'),
                    quickAccessContainer(
                        icon: Image.asset(
                          'assets/icons/ph_swap-fill.png',
                          color: AppColors.primaryColor,
                        ),
                        text: 'Airtime2cash'),
                    quickAccessContainer(
                        icon: const Icon(
                          Icons.more_horiz,
                          size: 16,
                          color: AppColors.primaryColor,
                        ),
                        text: 'More'),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 316.h,
                  width: MediaQuery.of(context).size.width,
                  child: const CarouselComponent(),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'History',
                  style: AppText.mediumStyle.copyWith(fontSize: 16),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 1134.h,
                  child: const HistoryComponent(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget quickAccessContainer({required Widget icon, required String text}) {
  return Container(
    height: 50.h,
    decoration: BoxDecoration(
        color: AppColors.whiteColor,
        border: Border.all(color: AppColors.primaryColor),
        borderRadius: BorderRadius.circular(10)),
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          Text(
            text,
            style: AppText.mediumStyle
                .copyWith(color: AppColors.primaryColor, letterSpacing: 0.092),
          )
        ],
      ),
    ),
  );
}
