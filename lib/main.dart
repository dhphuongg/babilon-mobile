import 'dart:io';

import 'package:babilon/firebase_options.dart';
import 'package:babilon/infrastructure/services/notification.service.dart';
import 'package:babilon/infrastructure/services/socket_client.service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:babilon/core/domain/resources/client_provider.dart';
import 'package:babilon/core/domain/utils/navigation_services.dart';
import 'package:babilon/di.dart';
import 'package:babilon/presentation/routes/app_router.dart';
import 'package:babilon/presentation/routes/init_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print('Handling a background message ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load .env file
  await dotenv.load(fileName: '.env');

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // DI init
  await configureDependencies();

  // Read url from env and use for baseUrl in init
  await RestClientProvider.init();

  // Initial Widget
  await InitRoute().getInitialRoute();

  if (Platform.isWindows) {
    databaseFactory = databaseFactoryFfi;
  }

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(EasyLocalization(
    supportedLocales: const [Locale('en', 'US'), Locale('vi', 'VN')],
    path: 'assets/translations',
    fallbackLocale: const Locale('vi', 'VN'),
    startLocale: const Locale('vi', 'VN'),
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppRoutes _appRoute = AppRoutes();

  NotificationServices notificationServices = NotificationServices();

  void initFirebase() async {
    await notificationServices.initialize();
    await notificationServices.requestPermission();
    await notificationServices.getDeviceToken().then((value) {
      print('Device Token : $value');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initFirebase();
    getIt<SocketClientService>().initialize();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      designSize: const Size(375, 812),
      builder: (_, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: NavigationService.navigatorKey,
        // set property
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        builder: (BuildContext context, Widget? child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.0)),
          child: child!,
        ),
        locale: context.locale,
        title: 'Babilon',
        onGenerateRoute: _appRoute.onGenerateRoute,
        theme: ThemeData(
          fontFamily: 'Visby',
          textTheme: TextTheme(
            bodyMedium: TextStyle(fontSize: 14.sp),
            bodyLarge: TextStyle(fontSize: 14.sp),
            displayMedium: TextStyle(fontSize: 14.sp),
          ),
          appBarTheme: const AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle.light,
          ),
        ),
      ),
    );
  }
}
