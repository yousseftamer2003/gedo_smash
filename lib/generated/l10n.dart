// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Choose\nYour Favorite Food`
  String get choose_your_favorite_food {
    return Intl.message(
      'Choose\nYour Favorite Food',
      name: 'choose_your_favorite_food',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Points`
  String get points {
    return Intl.message(
      'Points',
      name: 'points',
      desc: '',
      args: [],
    );
  }

  /// `See All`
  String get see_all {
    return Intl.message(
      'See All',
      name: 'see_all',
      desc: '',
      args: [],
    );
  }

  /// `Deals`
  String get deals {
    return Intl.message(
      'Deals',
      name: 'deals',
      desc: '',
      args: [],
    );
  }

  /// `Discount`
  String get discount {
    return Intl.message(
      'Discount',
      name: 'discount',
      desc: '',
      args: [],
    );
  }

  /// `Popular Food`
  String get popular_food {
    return Intl.message(
      'Popular Food',
      name: 'popular_food',
      desc: '',
      args: [],
    );
  }

  /// `Select Language`
  String get select_language {
    return Intl.message(
      'Select Language',
      name: 'select_language',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get English {
    return Intl.message(
      'English',
      name: 'English',
      desc: '',
      args: [],
    );
  }

  /// `Arabic`
  String get Arabic {
    return Intl.message(
      'Arabic',
      name: 'Arabic',
      desc: '',
      args: [],
    );
  }

  /// `No discount items available`
  String get no_discount_items_available {
    return Intl.message(
      'No discount items available',
      name: 'no_discount_items_available',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get all {
    return Intl.message(
      'All',
      name: 'all',
      desc: '',
      args: [],
    );
  }

  /// `No favorites yet!`
  String get no_favorites_yet {
    return Intl.message(
      'No favorites yet!',
      name: 'no_favorites_yet',
      desc: '',
      args: [],
    );
  }

  /// `Favorites`
  String get favorites {
    return Intl.message(
      'Favorites',
      name: 'favorites',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get Profile {
    return Intl.message(
      'Profile',
      name: 'Profile',
      desc: '',
      args: [],
    );
  }

  /// `Welcome,`
  String get Welcome {
    return Intl.message(
      'Welcome,',
      name: 'Welcome',
      desc: '',
      args: [],
    );
  }

  /// `Personal Info`
  String get personal_info {
    return Intl.message(
      'Personal Info',
      name: 'personal_info',
      desc: '',
      args: [],
    );
  }

  /// `Addresses`
  String get addresses {
    return Intl.message(
      'Addresses',
      name: 'addresses',
      desc: '',
      args: [],
    );
  }

  /// `My Orders`
  String get my_orders {
    return Intl.message(
      'My Orders',
      name: 'my_orders',
      desc: '',
      args: [],
    );
  }

  /// `Log Out`
  String get log_out {
    return Intl.message(
      'Log Out',
      name: 'log_out',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Redeeem points`
  String get redeeem_points {
    return Intl.message(
      'Redeeem points',
      name: 'redeeem_points',
      desc: '',
      args: [],
    );
  }

  /// `No offers available`
  String get no_offers_available {
    return Intl.message(
      'No offers available',
      name: 'no_offers_available',
      desc: '',
      args: [],
    );
  }

  /// `Cart Details`
  String get cart_details {
    return Intl.message(
      'Cart Details',
      name: 'cart_details',
      desc: '',
      args: [],
    );
  }

  /// `No items in cart yet`
  String get no_items_in_cart {
    return Intl.message(
      'No items in cart yet',
      name: 'no_items_in_cart',
      desc: '',
      args: [],
    );
  }

  /// `Total`
  String get total {
    return Intl.message(
      'Total',
      name: 'total',
      desc: '',
      args: [],
    );
  }

  /// `Checkout`
  String get checkout {
    return Intl.message(
      'Checkout',
      name: 'checkout',
      desc: '',
      args: [],
    );
  }

  /// `Add to cart`
  String get add_to_cart {
    return Intl.message(
      'Add to cart',
      name: 'add_to_cart',
      desc: '',
      args: [],
    );
  }

  /// `Total Food`
  String get total_food {
    return Intl.message(
      'Total Food',
      name: 'total_food',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Fee`
  String get delivery_fee {
    return Intl.message(
      'Delivery Fee',
      name: 'delivery_fee',
      desc: '',
      args: [],
    );
  }

  /// `Total Tax`
  String get total_tax {
    return Intl.message(
      'Total Tax',
      name: 'total_tax',
      desc: '',
      args: [],
    );
  }

  /// `EGP`
  String get Egp {
    return Intl.message(
      'EGP',
      name: 'Egp',
      desc: '',
      args: [],
    );
  }

  /// `Details`
  String get details {
    return Intl.message(
      'Details',
      name: 'details',
      desc: '',
      args: [],
    );
  }

  /// `Ingredients`
  String get ingredients {
    return Intl.message(
      'Ingredients',
      name: 'ingredients',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'extra_&_excludes' key

  /// `Add on order`
  String get add_on_order {
    return Intl.message(
      'Add on order',
      name: 'add_on_order',
      desc: '',
      args: [],
    );
  }

  /// `No extras available`
  String get no_extras_available {
    return Intl.message(
      'No extras available',
      name: 'no_extras_available',
      desc: '',
      args: [],
    );
  }

  /// `Item added to cart`
  String get item_added_to_cart {
    return Intl.message(
      'Item added to cart',
      name: 'item_added_to_cart',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get continueee {
    return Intl.message(
      'Continue',
      name: 'continueee',
      desc: '',
      args: [],
    );
  }

  /// `History`
  String get history {
    return Intl.message(
      'History',
      name: 'history',
      desc: '',
      args: [],
    );
  }

  /// `Ongoing`
  String get ongoing {
    return Intl.message(
      'Ongoing',
      name: 'ongoing',
      desc: '',
      args: [],
    );
  }

  /// `No order history`
  String get no_order_history {
    return Intl.message(
      'No order history',
      name: 'no_order_history',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'you_haven\'t_made_any_purchase_yet' key

  /// `Explore Menu`
  String get explore_menu {
    return Intl.message(
      'Explore Menu',
      name: 'explore_menu',
      desc: '',
      args: [],
    );
  }

  /// `Redeem In Restaurant?`
  String get redeem_in_restaurant {
    return Intl.message(
      'Redeem In Restaurant?',
      name: 'redeem_in_restaurant',
      desc: '',
      args: [],
    );
  }

  /// `Scan the code in the restaurant within 3 miniutes`
  String get scan_the_code_in_the_restaurant_within_3_mins {
    return Intl.message(
      'Scan the code in the restaurant within 3 miniutes',
      name: 'scan_the_code_in_the_restaurant_within_3_mins',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Redeem`
  String get redeem {
    return Intl.message(
      'Redeem',
      name: 'redeem',
      desc: '',
      args: [],
    );
  }

  /// `Order Summary`
  String get order_summary {
    return Intl.message(
      'Order Summary',
      name: 'order_summary',
      desc: '',
      args: [],
    );
  }

  /// `Choose Pickup or Delivery`
  String get Choose_Pickup_or_Delivery {
    return Intl.message(
      'Choose Pickup or Delivery',
      name: 'Choose_Pickup_or_Delivery',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
