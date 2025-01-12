import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food2go_app/constants/colors.dart';
import 'package:food2go_app/delivery/views/history_delivery_screen.dart';
import 'package:food2go_app/delivery/views/home_delivery_screen.dart';
import 'package:food2go_app/delivery/views/profile_delivery_screen.dart';

class TabsDeliveryScreen extends StatefulWidget {
  const TabsDeliveryScreen({super.key});

  @override
  State<TabsDeliveryScreen> createState() => _TabsDeliveryScreenState();
}

class _TabsDeliveryScreenState extends State<TabsDeliveryScreen> {
  var _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              children: const [
                HomeDeliveryScreen(),
                HistoryDeliveryScreen(),
                ProfileDeliveryScreen(),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 20, // This sets the floating effect
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  height: 50,
                  color: maincolor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _bottomNavBarIcon(
                        iconOn: 'assets/images/home_on.svg',
                        iconOff: 'assets/images/home_off.svg',
                        index: 0,
                      ),
                      _bottomNavBarIcon(
                        iconOn: 'assets/images/history_off.svg',
                        iconOff: 'assets/images/history_on.svg',
                        index: 1,
                      ),
                      _bottomNavBarIcon(
                        iconOn: 'assets/images/person_on.svg',
                        iconOff: 'assets/images/person_off.svg',
                        index: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomNavBarIcon(
      {String? iconOn, required String iconOff, required int index}) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
          _pageController.jumpToPage(index);
        });
      },
      child: SvgPicture.asset(isSelected ? iconOn ?? iconOff : iconOff),
    );
  }
}
