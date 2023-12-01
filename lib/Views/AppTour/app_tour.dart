import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vmpa/Constant/color.dart';
import 'package:vmpa/Views/Landing/landing.dart';

class ApplicationTour extends StatefulWidget {
  const ApplicationTour({super.key});

  @override
  ApplicationTourState createState() => ApplicationTourState();
}

class ApplicationTourState extends State<ApplicationTour> {
  final List<String> imageUrls = [
    'assets/images/jpg/page1.jpg',
    'assets/images/jpg/page2.jpg',
    'assets/images/jpg/page3.jpg',
    'assets/images/jpg/page4.jpg',
    'assets/images/jpg/page5.jpg',
    'assets/images/jpg/page6.jpg',
  ];

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    checkCarouselStatus();
  }

  void checkCarouselStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool carouselShown = prefs.getBool('carouselShown') ?? false;

    if (carouselShown) {
      Get.offAll(() => const LandingView());
    } else {
      prefs.setBool('carouselShown', true);
    }
  }

  void navigateToHome() {
    Future.delayed(const Duration(seconds: 3), () {
      Get.offAll(() => const LandingView());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('App Tour')),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: CarouselSlider(
                items: imageUrls.map((imageUrl) {
                  return Image.asset(
                    imageUrl,
                    fit: BoxFit.cover,
                  );
                }).toList(),
                options: CarouselOptions(
                  height: MediaQuery.of(context).size.height / 1.3,
                  enlargeCenterPage: true,
                  autoPlay: true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentIndex = index;
                    });
                    if (index == imageUrls.length - 1) {
                      navigateToHome();
                    }
                  },
                ),
              ),
            ),
            ValueListenableBuilder<int>(
              valueListenable: ValueNotifier<int>(_currentIndex),
              builder: (context, currentIndex, _) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: imageUrls.map((url) {
                    int index = imageUrls.indexOf(url);
                    return Container(
                      width: 8.0,
                      height: 8.0,
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: currentIndex == index ? AppColors.blue : AppColors.grey,
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
