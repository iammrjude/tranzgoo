import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tranzgoo/utils/theme/app_colors.dart';
import 'package:tranzgoo/utils/theme/app_style.dart';
import 'package:tranzgoo/utils/widget/app_button.dart';
import 'package:tranzgoo/utils/widget/app_textfield.dart';

class SendView extends StatefulWidget {
  const SendView({Key? key}) : super(key: key);

  @override
  State<SendView> createState() => _SendViewState();
}

class _SendViewState extends State<SendView> {
  final TextEditingController tranzgoId = TextEditingController();
  final TextEditingController amount = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Send',
              style:
                  AppText.extraBold.copyWith(fontSize: 16, letterSpacing: 0.09),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Transfer funds to another user on \nTransGO.',
              textAlign: TextAlign.center,
              style: AppText.regularStyle.copyWith(letterSpacing: 0.09),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              'TranzGOO ID',
              style: AppText.extraBold.copyWith(color: AppColors.primaryColor),
            ),
            const SizedBox(
              height: 5,
            ),
            AppTextField(
              controller: tranzgoId,
              textCenter: true,
              hintText: '* * * * * *',
              width: 254.w,
            ),
            Text(
              'Amount',
              style: AppText.extraBold.copyWith(color: AppColors.primaryColor),
            ),
            const SizedBox(
              height: 5,
            ),
            AppTextField(
              textCenter: true,
              controller: amount,
              hintText: '0.00',
              width: 254.w,
            ),
            const SizedBox(
              height: 55,
            ),
            AppButton(
              onPressed: () {},
              label: 'Send',
              isText: true,
            )
          ],
        ),
      ),
    );
  }
}
