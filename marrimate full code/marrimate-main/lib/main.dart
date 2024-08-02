import 'dart:io';
import 'package:country_code_picker/country_localizations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:marrimate/Screens/splash_screen.dart';
import 'package:marrimate/models/partner_model.dart';
import 'package:marrimate/models/user_model.dart';
import 'package:marrimate/models/match_model.dart';
import 'package:marrimate/services/navigation.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'models/filters_model.dart';
import 'models/my_story_model.dart';
import 'models/new_quiz_model.dart';
import 'models/story_model.dart';

void main() async{
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Firebase.initializeApp();
  await EasyLocalization.ensureInitialized();
  NavigationService().setupLocator();
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<UserModel>(create: (_) => UserModel()),
          ChangeNotifierProvider<Filters>(create: (_) => Filters()),
          ChangeNotifierProvider<MyStories>(create: (_) => MyStories()),
          ChangeNotifierProvider<MatchedStories>(create: (_) => MatchedStories()),
          ChangeNotifierProvider<Match>(create: (_) => Match()),
          ChangeNotifierProvider<Partner>(create: (_) => Partner()),
          ChangeNotifierProvider<NewQuiz>(create: (_) => NewQuiz()),
    ],
    child: EasyLocalization(
        supportedLocales: const [
          Locale('en'), Locale('hi'), Locale('zh'),
          Locale('it'), Locale('pt'), Locale('ko'),
          Locale('fr')
        ],
        startLocale: Locale('en'),
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        child: const MyApp()
    ),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      localizationsDelegates: context.localizationDelegates + [
        CountryLocalizations.delegate
      ],
      supportedLocales: context.supportedLocales,
      locale: context.locale,
       /*supportedLocales: const [
         //Locale("de"),
         Locale("en"),
         Locale("hi"),
         Locale("fr"),
         Locale("it"),
         Locale("ko"),
         Locale("pl"),
         Locale("pt"),
         Locale("zh")
       ],
      locale: _locale,
      localizationsDelegates: const [
        //CountryLocalizations.delegate
        DemoLocalization.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode &&
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },*/
      navigatorKey: locator<NavigationService>().navigatorKey,
      home: const SplashScreen(),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}