import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:food2go_app/controllers/Auth/login_provider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../models/offer/offer_model.dart';

class OfferProvider with ChangeNotifier {
  List<Offer> _offers = [];
  bool _isLoading = false;

  List<Offer> get offers => _offers;
  bool get isLoading => _isLoading;

  Future<void> fetchOffers(BuildContext context) async {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    final String token = loginProvider.token!;

    const String url = 'https://Gedobcknd.food2go.online/customer/offers';
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _offers = (data['offers'] as List)
            .map((offerJson) => Offer.fromJson(offerJson))
            .toList();
      } else {
        log(response.body);
        throw Exception('Failed to load offers');
      }
    } catch (e) {
      log('Error fetching offers: $e');
      throw Exception('Error fetching offers: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> buyOffer(
      BuildContext context, int offerId) async {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    final String token = loginProvider.token!;

    const String url = 'https://Gedobcknd.food2go.online/customer/offers/buy_offer';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'offer_id': offerId,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        log(response.body);
        log('Offer purchased successfully');
        return data; // Return the parsed response
      } else {
        log('Failed to purchase offer: ${response.body}');
        throw Exception('Failed to purchase offer');
      }
    } catch (e) {
      log('Error purchasing offer: $e');
      throw Exception('Error purchasing offer: $e');
    }
  }
}
