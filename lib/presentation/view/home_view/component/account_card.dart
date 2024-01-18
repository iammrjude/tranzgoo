import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tranzgoo/utils/theme/app_colors.dart';
import 'package:tranzgoo/utils/theme/app_style.dart';

class AccountCard extends StatelessWidget {
  const AccountCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.primaryColor,
        border: Border.all(color: AppColors.grey300, width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Account Balance',
            style: AppText.extraBold
                .copyWith(color: AppColors.whiteColor, fontSize: 16),
          ),
          Row(
            children: [
              Text(
                '₦ 1,000,000',
                style: AppText.extraBold
                    .copyWith(color: AppColors.whiteColor, fontSize: 20),
              ),
              const SizedBox(
                width: 10,
              ),
              const Icon(
                Icons.visibility,
                size: 14,
                color: AppColors.whiteColor,
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, '/sendView');
                },
                child: Container(
                  height: 39.h,
                  width: 118.w,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppColors.whiteColor),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset('assets/icons/sendIcon.png'),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        'send',
                        style: AppText.extraBold.copyWith(
                            color: AppColors.primaryColor, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/fundAccountView');
                },
                child: Container(
                  height: 39.h,
                  width: 151.w,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppColors.whiteColor),
                  child: Row(
                    children: [
                      Image.asset('assets/icons/addIcon.png'),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Fund Account',
                        style: AppText.extraBold.copyWith(
                            color: AppColors.primaryColor, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
