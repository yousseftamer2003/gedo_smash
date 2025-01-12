import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food2go_app/controllers/business_setup_controller.dart';
import 'package:food2go_app/controllers/chat/userChat/get_messages_provider.dart';
import 'package:food2go_app/controllers/chat/userChat/send_message_provider.dart';
import 'package:food2go_app/controllers/lang_services_controller.dart';
import 'package:food2go_app/controllers/tabs_controller.dart';
import 'package:food2go_app/generated/l10n.dart';
import 'package:provider/provider.dart';
import 'package:food2go_app/controllers/Auth/forget_password_provider.dart';
import 'package:food2go_app/controllers/Auth/login_provider.dart';
import 'package:food2go_app/controllers/Auth/sign_up_provider.dart';
import 'package:food2go_app/controllers/address/get_address_provider.dart';
import 'package:food2go_app/controllers/banners/banners_provider.dart';
import 'package:food2go_app/controllers/categories/categories_provider.dart';
import 'package:food2go_app/controllers/checkout/deal_checkout_provider.dart';
import 'package:food2go_app/controllers/checkout/place_order_provider.dart';
import 'package:food2go_app/controllers/deal/deal_provider.dart';
import 'package:food2go_app/controllers/delivery/history_delivery_provider.dart';
import 'package:food2go_app/controllers/delivery/order_provider.dart';
import 'package:food2go_app/controllers/delivery/profile_delivery_provider.dart';
import 'package:food2go_app/controllers/notification_controller.dart';
import 'package:food2go_app/controllers/orders/orders_history_provider.dart';
import 'package:food2go_app/controllers/orders/orders_provider.dart';
import 'package:food2go_app/controllers/product_provider.dart';
import 'package:food2go_app/controllers/profile/edit_profile_provider.dart';
import 'package:food2go_app/controllers/profile/get_profile_provider.dart';
import 'package:food2go_app/firebase_options.dart';
import 'package:food2go_app/view/screens/splash_screen/logo_onboarding.dart';
import 'controllers/chat/chat_delivery_provider.dart';
import 'controllers/checkout/image_provider.dart';
import 'controllers/offer/offer_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => SignUpProvider()),
        ChangeNotifierProvider(create: (_) => CategoriesProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => GetProfileProvider()),
        ChangeNotifierProvider(create: (_) => DealProvider()),
        ChangeNotifierProvider(create: (_) => EditProfileProvider()),
        ChangeNotifierProvider(create: (_) => OtpProvider()),
        ChangeNotifierProvider(create: (_) => OrdersProvider()),
        ChangeNotifierProvider(create: (_) => OrdersHistoryProvider()),
        ChangeNotifierProvider(create: (_) => AddressProvider()),
        ChangeNotifierProvider(create: (_) => BannerProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => OrderdeliveryProvider()),
        ChangeNotifierProvider(create: (_) => DeliveryUserProvider()),
        ChangeNotifierProvider(create: (_) => OrderHistoryProvider()),
        ChangeNotifierProvider(create: (_) => OrderTypesAndPaymentsProvider()),
        ChangeNotifierProvider(create: (_) => NotificationController()),
        ChangeNotifierProvider(create: (_) => ImageServices()),
        ChangeNotifierProvider(create: (_) => OfferProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => GetMessagesProvider()),
        ChangeNotifierProvider(create: (_) => SendMessageProvider()),
        ChangeNotifierProvider(create: (_) => TabsController()),
        ChangeNotifierProvider(create: (_) => BusinessSetupController()),
        ChangeNotifierProvider(create: (_) => LangServices()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        builder: (context, child) => Consumer<LangServices>(
          builder: (context, langServices, _) {
            return MaterialApp(
            locale: langServices.locale,
            localizationsDelegates: const [
                  S.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: S.delegate.supportedLocales,
            theme: ThemeData(
              fontFamily: 'Poppins',
              scaffoldBackgroundColor: Colors.grey.shade100,
              appBarTheme: AppBarTheme(backgroundColor: Colors.grey.shade100),
            ),
            debugShowCheckedModeBanner: false,
            title: 'Food2go',
            home: const LogoOnboarding(),
          );
          },
        ),
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
