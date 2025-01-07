import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:madweek22/view/appointment_page.dart';
import 'package:madweek22/view/home_view.dart';
import 'package:madweek22/view/login_view.dart';
import 'package:madweek22/view/splash_view.dart';
import 'package:madweek22/view/map_view.dart';
import 'package:madweek22/viewModel/appointment_view_model.dart';
import 'package:madweek22/viewModel/home_view_model.dart';
import 'package:madweek22/viewModel/login_view_model.dart';
import 'package:madweek22/viewModel/station_view_model.dart';
import 'package:madweek22/viewModel/user_view_model.dart';
import 'package:madweek22/viewModel/map_view_model.dart';
import 'package:provider/provider.dart';
import 'package:madweek22/view/signup_view.dart';
import 'package:madweek22/viewModel/signup_view_model.dart';

Future<void> main() async {
  // .env 파일 로드
  await dotenv.load(fileName: ".env");
  // 앱 실행
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => SignupViewModel()),
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProvider(create: (_) => StationViewModel()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => AppointmentViewModel()),
        ChangeNotifierProvider(create: (_) => MapViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => SplashScreen(),
          'login' : (context) => LoginView(),
          '/signup': (context) => SignupView(),
          '/home' : (context) => HomeView(),
          '/appointment' : (context) => AppointmentPage(),
        },
      ),
    );
  }
}

