import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tranzgoo/utils/theme/app_colors.dart';
import 'package:tranzgoo/utils/theme/app_style.dart';

class HistoryComponent extends StatefulWidget {
  const HistoryComponent({Key? key}) : super(key: key);

  @override
  State<HistoryComponent> createState() => _HistoryComponentState();
}

class _HistoryComponentState extends State<HistoryComponent> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Fri \n10',
                  style: AppText.lightStyle,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text.rich(
                      TextSpan(
                        text: 'MTN Recharge ',
                        style: AppText.extraBold,
                        children: [
                          TextSpan(text: 'to', style: AppText.lightStyle)
                        ],
                      ),
                    ),
                    const Text('08054200231'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 33.h,
                          width: 112.w,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: AppColors.primaryLightColor),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Paid via',
                                    style: AppText.lightStyle.copyWith(
                                        fontSize: 7, letterSpacing: 0),
                                  ),
                                  Text(
                                    'Voucher',
                                    style: AppText.extraBold.copyWith(
                                        fontSize: 7, letterSpacing: 0),
                                  ),
                                ],
                              ),
                              Image.asset('assets/images/Component 12.png')
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 100.w,
                        ),
                        const Text(
                          '₦1,000',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }
}
