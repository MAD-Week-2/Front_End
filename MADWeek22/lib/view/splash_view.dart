
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'login_view.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginView()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Transform.translate(
                offset: Offset(0, -50),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // LG Follow 로고 이미지
                    Image.asset(
                      'assets/images/bike.png',
                      height: 150,
                      width: 150,
                    ),
                    SizedBox(height: 8),


                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
