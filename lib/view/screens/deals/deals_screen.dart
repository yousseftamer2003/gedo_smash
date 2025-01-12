// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:food2go_app/controllers/deal/deal_provider.dart';
import 'package:food2go_app/view/screens/tabs_screens/widgets/deals_card.dart';
import 'package:food2go_app/view/widgets/custom_appbar.dart';

import 'deals_details_screen.dart';

class DealsScreen extends StatefulWidget {
  const DealsScreen({super.key});

  @override
  _DealsScreenState createState() => _DealsScreenState();
}

class _DealsScreenState extends State<DealsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      // ignore: use_build_context_synchronously
      Provider.of<DealProvider>(context, listen: false).fetchDeals(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, 'Deals'),
      body: Consumer<DealProvider>(
        builder: (context, dealProvider, child) {
          if (dealProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (dealProvider.deals.isEmpty) {
            return const Center(child: Text('No deals available'));
          }

          return SingleChildScrollView(
            child: Column(
              children: dealProvider.deals.map((deal) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DealsDetailsScreen(deal: deal),
                      ),
                    );
                  },
                  child: DealsCard(
                    title: deal.title,
                    description: deal.description ?? 'No description available',
                    price: deal.price,
                    image: deal.image ?? 'assets/images/dealsandwich.png',
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
