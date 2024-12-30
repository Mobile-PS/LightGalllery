

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:light_gallery/home/dashboard.dart';
import 'package:light_gallery/sign_in/sign_in.dart';

import '../preferences/pref_repository.dart';
import '../utils/constant/const_color.dart';
import '../utils/constant/constants.dart';




class SplashScreen extends StatefulWidget {

  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreen createState() => _SplashScreen();
}


class _SplashScreen extends State<SplashScreen> {

  final _prefRepo = PrefRepository();

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 4), () {

      navigate();

    });
  }

  navigate() async {
    final profileResponse = await _prefRepo.getLoginUserData();

    if (profileResponse?.data?.id != null) {
      Get.offAll(DashboardScreen());
    }
    else {
      Get.offAll(SigninScreen());
    }
  }

      @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundcolor1,
      body:  Center(
          child:
          SizedBox(
            height: 200.0,
            width: context.width/1.2,
            child: Image.asset(constImage.splashImage,fit: BoxFit.fitWidth,),
          ),
        ),


    );

  }

}
