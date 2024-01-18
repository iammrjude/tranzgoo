import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tranzgoo/utils/theme/app_style.dart';

import '../../../utils/theme/app_colors.dart';

class FundAccount extends StatefulWidget {
  const FundAccount({Key? key}) : super(key: key);

  @override
  State<FundAccount> createState() => _FundAccountState();
}

class _FundAccountState extends State<FundAccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Fund Account',
          style: AppText.extraBold,
        ),
        actions: [
          Container(
            height: 23.h,
            width: 23.w,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
                border: Border.all(color: AppColors.primaryColor),
                borderRadius: BorderRadius.circular(6),
                color: AppColors.whiteColor),
            child: Image.asset('assets/icons/notification.png'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Transfer to any of the account \nnumber below to fund your account.',
                textAlign: TextAlign.center,
                style: AppText.mediumStyle.copyWith(letterSpacing: 0.09),
              ),
              Text(
                'Account name: transgo john',
                style: AppText.bold.copyWith(
                    color: AppColors.primaryColor, letterSpacing: 0.09),
              ),
              const SizedBox(
                height: 10,
              ),
              fundAccountContainer('Moniepoint', '1234567890'),
              fundAccountContainer('Wema Bank', '1234567890'),
              fundAccountContainer('Fidelity Bank', '1234567890'),
            ],
          ),
        ),
      ),
    );
  }
}

Widget fundAccountContainer(String text, String numberText) {
  return Container(
    height: 105.h,
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    decoration: BoxDecoration(
      color: AppColors.primaryColor,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.grey300,width: 2),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: AppText.extraBold.copyWith(color: AppColors.whiteColor),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Account no.'),
                Text(
                  numberText,
                  style:
                      AppText.extraBold.copyWith(color: AppColors.whiteColor),
                ),
              ],
            ),
            const Column(
              children: [
                Icon(
                  Icons.copy_rounded,
                  size: 16,
                  color: AppColors.whiteColor,
                ),
                Text(
                  'Copy',
                  style: TextStyle(color: AppColors.whiteColor),
                )
              ],
            )
          ],
        )
      ],
    ),
  );
}
