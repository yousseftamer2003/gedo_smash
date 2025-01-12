import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food2go_app/constants/colors.dart';
import 'package:food2go_app/controllers/tabs_controller.dart';
import 'package:food2go_app/view/screens/cart/cart_details.dart';
import 'package:food2go_app/view/screens/tabs_screens/screens/favourites_screen.dart';
import 'package:food2go_app/view/screens/tabs_screens/screens/home_screen.dart';
import 'package:food2go_app/view/screens/tabs_screens/screens/profile_screen/profile_screen.dart';
import 'package:food2go_app/view/screens/points/points_items_screen.dart';
import 'package:provider/provider.dart';
import 'package:food2go_app/controllers/product_provider.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key, required this.initialIndex});
  final int initialIndex;

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  var _currentIndex = 0;
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex; // Set the initial index
    _pageController = PageController(initialPage: _currentIndex); // Initialize PageController with initial index
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(0),
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                Provider.of<TabsController>(context, listen: false).setIndex(index);
                setState(() {
                  _currentIndex = index;
                });
              },
              children: [
                const HomeScreen(),
                const FavouritesScreen(),
                CartDetailssScreen(onBack: (int lastIndex) {
                  Provider.of<TabsController>(context, listen: false).setIndex(lastIndex);
                  _pageController.jumpToPage(lastIndex);
                }),
                const PointsItemsScreen(),
                const ProfileScreen(),
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
                        iconOn: 'assets/images/fav_on.svg',
                        iconOff: 'assets/images/fav_off.svg',
                        index: 1,
                      ),
                      _bottomNavBarIcon(
                        iconOn: 'assets/images/cart_on.svg',
                        iconOff: 'assets/images/cart_pff.svg',
                        index: 2,
                        showCartLength: true,
                      ),
                      _bottomNavBarIcon(
                        iconOn: 'assets/images/Vector.svg',
                        iconOff: 'assets/images/Frame.svg',
                        index: 3,
                      ),
                      _bottomNavBarIcon(
                        iconOn: 'assets/images/person_on.svg',
                        iconOff: 'assets/images/person_off.svg',
                        index: 4,
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

  Widget _bottomNavBarIcon({
    required String iconOff,
    required int index,
    String? iconOn,
    bool showCartLength = false,
  }) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
          _pageController.jumpToPage(index);
        });
      },
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          index == 2
              ? Container(
                  padding: const EdgeInsets.all(8),
                  height: 50,
                  width: 50,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                  child: SvgPicture.asset(
                    isSelected ? iconOn ?? iconOff : iconOff,
                    // ignore: deprecated_member_use
                    color: maincolor,
                  ))
              : SvgPicture.asset(isSelected ? iconOn ?? iconOff : iconOff),
          if (showCartLength)
            Consumer<ProductProvider>(
              builder: (context, productProvider, child) {
                final cartLength = productProvider.cart.length;
                return cartLength > 0
                    ? Positioned(
                        top: 0,
                        right: -1,
                        child: CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.green,
                          child: Text(
                            '$cartLength',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink();
              },
            ),
        ],
      ),
    );
  }
}
