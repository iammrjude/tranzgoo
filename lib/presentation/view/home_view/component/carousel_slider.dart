import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tranzgoo/utils/theme/app_colors.dart';

class CarouselComponent extends StatefulWidget {
  const CarouselComponent({Key? key}) : super(key: key);

  @override
  State<CarouselComponent> createState() => _CarouselComponentState();
}

class _CarouselComponentState extends State<CarouselComponent> {
  int initialPage = 0;
  PageController pageController = PageController(
    viewportFraction: 0.957,
  );
  List<String> images = [
    'assets/images/Flyer 01 1.png',
    'assets/images/Flyer 01 1.png',
    'assets/images/Flyer 01 1.png',
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 294.h,
          child: PageView.builder(
              padEnds: false,
              controller: pageController,
              itemCount: images.length,
              onPageChanged: (e) {
                setState(
                  () {
                    initialPage = e;
                  },
                );
              },
              itemBuilder: (context, index) {
                return SizedBox(
                  height: 294.h,
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset(
                    images[index],
                  ),
                );
              }),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 10,
              height: 10,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: initialPage == 0 ? AppColors.primaryColor : Colors.grey,
              ),
            ),
            Container(
              width: 10,
              height: 10,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: initialPage == 1 ? AppColors.primaryColor : Colors.grey,
              ),
            ),
            Container(
              width: 10,
              height: 10,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: initialPage == 2 ? AppColors.primaryColor : Colors.grey,
              ),
            ),
          ],
        )
      ],
    );
  }
}
