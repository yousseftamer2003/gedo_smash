// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food2go_app/controllers/business_setup_controller.dart';
import 'package:food2go_app/generated/l10n.dart';
import 'package:food2go_app/view/screens/tabs_screens/widgets/closed_wrap_container.dart';
import 'package:provider/provider.dart';
import 'package:food2go_app/constants/colors.dart';
import 'package:food2go_app/controllers/offer/offer_provider.dart';
import 'package:food2go_app/controllers/profile/get_profile_provider.dart';
import 'package:food2go_app/view/screens/tabs_screens/widgets/points_card.dart';
import '../../../models/offer/offer_model.dart';
import '../checkout/code_checkout_screen.dart';
import '../tabs_screen.dart';

class PointsItemsScreen extends StatefulWidget {
  const PointsItemsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PointsItemsScreenState createState() => _PointsItemsScreenState();
}

class _PointsItemsScreenState extends State<PointsItemsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OfferProvider>(context, listen: false).fetchOffers(context);
    });
  }

  Future<void> handleOfferPress(Offer offer) async {
    showRedeemBottomSheet(context, offer);
  }

  @override
  Widget build(BuildContext context) {
    final businessSetupProvider = Provider.of<BusinessSetupController>(context, listen: false);
  String from = businessSetupProvider.from;
  String to = businessSetupProvider.to;

  // Parse the "from" and "to" time slots into DateTime objects
  final now = DateTime.now();
  final fromTime = DateTime(now.year, now.month, now.day,
      int.parse(from.split(':')[0]), int.parse(from.split(':')[1]));
  final toTime = DateTime(now.year, now.month, now.day,
      int.parse(to.split(':')[0]), int.parse(to.split(':')[1]));

  final isClosed = now.isAfter(fromTime) && now.isBefore(toTime);
    final profileProvider = Provider.of<GetProfileProvider>(context);
    final int mypoints = profileProvider.userProfile?.points ?? 0;

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: maincolor,
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const TabsScreen(initialIndex: 0,)),
              );
            },
          ),
          title: Center(
            child: Text(
              S.of(context).redeeem_points,
              style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 24),
            ),
          ),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 90.w,
                      height: 44.h,
                      margin: EdgeInsets.all(8.0.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            mypoints.toString(),
                            style: TextStyle(
                              color: maincolor,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(width: 7.w),
                          SvgPicture.asset(
                            'assets/images/coin.svg',
                            width: 16.w,
                            height: 16.h,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Consumer<OfferProvider>(
                    builder: (context, offerProvider, child) {
                      if (offerProvider.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (offerProvider.offers.isEmpty) {
                        return Center(child: Text(S.of(context).no_offers_available));
                      } else {
                        final data = offerProvider.offers;
                        return Padding(
                          padding: EdgeInsets.all(8.0.w),
                          child: GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 8.h,
                              crossAxisSpacing: 8.w,
                              childAspectRatio: 3 / 4,
                            ),
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              final offer = data[index];
                              return PointsCard(
                                image: offer.imageLink,
                                title: offer.product,
                                points: offer.points,
                                status: offer.points > mypoints ? 0 : 1,
                                onPressed: () => handleOfferPress(
                                    offer), // Pass offer ID to the function
                              );
                            },
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
            if (isClosed) ...[
            GestureDetector(
              onTap: () {}, // Blocks taps on the underlying widgets
              child: Container(
                color: Colors.black.withOpacity(0.6), // Semi-transparent overlay
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            Center(
              child: buildClosedWrap(context, from, to),
            ),
          ],
          ],
        ),
      ),
    );
  }
}

void showRedeemBottomSheet(BuildContext context, Offer offer) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.qr_code_scanner,
              size: 40,
              color: maincolor,
            ),
            const SizedBox(height: 16),
            Text(
              S.of(context).redeem_in_restaurant,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              S.of(context).scan_the_code_in_the_restaurant_within_3_mins,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 24),
            Divider(color: Colors.grey[300], thickness: 1),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.cancel,
                    color: maincolor,
                  ),
                  label: Text(
                    S.of(context).cancel,
                    style: const TextStyle(
                      color: maincolor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    // Perform the same logic as handleOfferPress
                    final response =
                        await Provider.of<OfferProvider>(context, listen: false)
                            .buyOffer(context, offer.id);

                    final refNumber = response['ref_number'].toString();

                    Navigator.push(
                      // ignore: use_build_context_synchronously
                      context,
                      MaterialPageRoute(
                        builder: (context) => CodeCheckoutScreen(
                          refNumber: refNumber,
                          title: offer.product, // Pass offer title
                          image: offer.imageLink, // Pass offer image
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: maincolor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    shadowColor: Colors.black26,
                  ),
                  icon: const Icon(
                    Icons.redeem,
                    color: Colors.white,
                  ),
                  label: Text(
                    S.of(context).redeem,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
