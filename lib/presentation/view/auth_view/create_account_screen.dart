import 'package:flutter/material.dart';
import 'package:tranzgoo/utils/theme/app_colors.dart';
import 'package:tranzgoo/utils/theme/app_style.dart';
import 'package:tranzgoo/utils/widget/app_button.dart';
import 'package:tranzgoo/utils/widget/responsive_layout.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({Key? key}) : super(key: key);

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: AppResponsiveScrollView(
        centerVertically: true,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/tranzgooLogo.png',
              color: AppColors.primaryColor,
              height: 60,
              width: 110,
            ),
            const SizedBox(
              height: 20,
            ),
            AppButton(
              onPressed: () {},
              label: '',
              backgroundColor: Colors.white,
              widget: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/icons/googleIcon.png',
                    width: 18,
                    height: 18,
                  ),
                  const SizedBox(
                    width: 7,
                  ),
                  Expanded(
                    child: Text(
                      'Continue with Goggle',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.extraBold.copyWith(
                        fontSize: 15,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            AppButton(
              onPressed: () {},
              label: '',
              backgroundColor: Colors.white,
              widget: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/icons/appleIcon.png',
                    width: 18,
                    height: 18,
                  ),
                  const SizedBox(
                    width: 7,
                  ),
                  Expanded(
                    child: Text(
                      'Continue with Apple',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.extraBold.copyWith(
                        fontSize: 15,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            AppButton(
              onPressed: () {},
              label: '',
              backgroundColor: Colors.white,
              widget: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/icons/microsoftIcon.png',
                    width: 18,
                    height: 18,
                  ),
                  const SizedBox(
                    width: 7,
                  ),
                  Expanded(
                    child: Text(
                      'Continue with Microsoft',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.extraBold.copyWith(
                        fontSize: 15,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            AppButton(
              onPressed: () {
                Navigator.pushNamed(context, '/registerView');
              },
              label: 'Sign Up',
              isText: true,
            ),
          ],
        ),
      ),
    );
  }
}
