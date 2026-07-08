import 'package:flutter/material.dart';
import 'package:tranzgoo/utils/theme/app_colors.dart';
import 'package:tranzgoo/utils/theme/app_style.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: AppText.extraBold,
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {}, icon: Image.asset('assets/icons/homeIcon.png'))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Profile',
                      style: AppText.extraBold
                          .copyWith(fontSize: 16, letterSpacing: 0.09),
                    ),
                    const Text('Manage your TransGo account from here'),
                  ],
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {},
                  icon: Image.asset('assets/icons/edit.png'),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(46),
              child: Image.asset('assets/images/person.png'),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'John Doe',
                      style: AppText.extraBold
                          .copyWith(fontSize: 16, letterSpacing: 0.09),
                    ),
                    const Text('johndoe@gmail.com'),
                  ],
                ),
                Column(
                  children: [
                    Text('TG ID',
                        style: AppText.bold.copyWith(letterSpacing: 0.09)),
                    Text(
                      'A200231',
                      style: AppText.lightStyle
                          .copyWith(fontSize: 10, letterSpacing: 0.09),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              'General settings',
              style: AppText.mediumStyle.copyWith(letterSpacing: 0.09),
            ),
            const SizedBox(
              height: 15,
            ),
            settingsWidget(
                child: Image.asset(
                  'assets/icons/Group 3.png',
                  height: 32,
                  width: 32,
                ),
                title: 'Personal Information',
                subTitle: 'Edit your information'),
            settingsWidget(
                child: Image.asset('assets/icons/mdi_talk.png'),
                title: 'Refer a friend',
                subTitle: 'Get rewards when you tell a friend'),
            settingsWidget(
                child: Image.asset('assets/icons/Vector.png'),
                title: 'Settings',
                subTitle: 'Security, Notification'),
            settingsWidget(
                child: Image.asset('assets/icons/Vector (1).png'),
                title: 'Dark Mode',
                subTitle: 'Use the toggle to turn on/off',
                icon: ToggleButtons(isSelected: const [], children: const [])),
            settingsWidget(
                child: Image.asset('assets/icons/bx_support.png'),
                title: 'Support',
                subTitle: 'Contact Us'),
            settingsWidget(
                child: Image.asset('assets/icons/ant-design_read-filled.png'),
                title: 'Legal',
                subTitle: 'Application rules, legal and policies'),
            settingsWidget(
              child: Image.asset('assets/icons/solar_logout-2-bold.png'),
              title: 'Logout',
              icon: const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}

Widget settingsWidget({
  Widget? child,
  String? title,
  String? subTitle,
  Widget? icon,
}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              height: 32,
              decoration: const BoxDecoration(
                  color: AppColors.whiteColor, shape: BoxShape.circle),
              child: child,
            ),
            const SizedBox(
              width: 8,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title ?? '',
                  style:
                      AppText.bold.copyWith(fontSize: 14, letterSpacing: 0.09),
                ),
                Text(
                  subTitle ?? '',
                  style: AppText.mediumStyle
                      .copyWith(fontSize: 11, letterSpacing: 0.09),
                ),
              ],
            )
          ],
        ),
        icon ??
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: AppColors.primaryColor,
            )
      ],
    ),
  );
}
