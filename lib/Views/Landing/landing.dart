import 'package:flutter/material.dart';
import 'package:vmpa/Constant/color.dart';
import 'package:vmpa/Views/Home/home.dart';
import 'package:vmpa/Views/Recommend/recommand.dart';
import 'package:vmpa/Views/Upload/upload_page.dart';

class LandingView extends StatefulWidget {
  const LandingView({Key? key}) : super(key: key);

  @override
  State<LandingView> createState() => _LandingViewState();
}

class _LandingViewState extends State<LandingView> {
  List<Widget> screens = [
    const HomeView(),
    const UploadPage(),
    const ReccomendView(isAdmin: false, userUploads: false)
  ];

  int selectedIndex = 0;
  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.black,
      body: screens.elementAt(selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.primary,
        selectedItemColor: AppColors.white,
        unselectedItemColor: AppColors.white54,
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        selectedLabelStyle: Theme.of(context).textTheme.titleSmall,
        unselectedLabelStyle: Theme.of(context).textTheme.titleSmall,
        elevation: 1.5,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled, size: 30), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.add, size: 30), label: 'Upload'),
          BottomNavigationBarItem(icon: Icon(Icons.featured_play_list, size: 30), label: 'Recommended'),
        ],
      ),
    );
  }
}
