import 'package:flutter/material.dart';
import 'package:tranzgoo/utils/theme/app_colors.dart';
import 'package:tranzgoo/utils/widget/responsive_layout.dart';

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
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.hasBoundedWidth
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;
        final bannerHeight = AppResponsive.clampDouble(width * 0.72, 180, 300);

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: bannerHeight,
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
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Image.asset(
                      images[index],
                      fit: BoxFit.contain,
                      width: double.infinity,
                      height: bannerHeight,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                images.length,
                (index) => Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: initialPage == index
                        ? AppColors.primaryColor
                        : Colors.grey,
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
