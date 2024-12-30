
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get.dart';

import '../sign_in/sign_in.dart';
import '../splash_screen/splash_screen.dart';


List<GetPage> routes = [
  GetPage(
    name: '/',
    page: () => SplashScreen(),
  ),
   GetPage(
     name: '/signin_screen',
     page: () => SigninScreen(),
   ),
  // GetPage(
  //   name: '/main',
  //   page: () => OnboardingScreen(),
  // ),
  // GetPage(
  //   name: '/home',
  //   page: () => TodayScreen(),
  // ),
  // GetPage(
  //   name: '/general_screen',
  //   page: () => GeneralDetailScreen(),
  // ),
  // GetPage(
  //   name: '/dmc_screen',
  //   page: () => DMCListScreen(),
  // ),

  /*
  GetPage(
    name: '/signin_screen',
    page: () => SigninScreen(),
  ),
  GetPage(
    name: '/signup_screen',
    page: () => SignUpScreen(),
  ),

  GetPage(
    name: '/ChooseScreen',
    page: () => ChooseScreen(),
  ),

  GetPage(
    name: '/CreateAccountScreen',
    page: () => CreateAccountScreen(),
  ),

  GetPage(
    name: '/BuyerSalerAccountScreen',
    page: () => AddressScreen(),
  ),

  GetPage(
    name: '/AgentProfileScreen',
    page: () => AgentProfileScreen(),
  ),

  GetPage(
    name: '/AgentMoreDetailsScreen',
    page: () => AgentMoreDetailsScreen(),
  ),

  GetPage(
    name: '/RealEstateInterestScreen',
    page: () => InterestScreen(),
  ),

  GetPage(
    name: '/AgentAddressScreen',
    page: () => AgentAddressScreen(),
  ),
  GetPage(
    name: '/MobileOtpScreen',
    page: () => OtpScreen(),
  ),
*/

];

// note that you can create separated file for grouped route
List<GetPage> pages() {
  return routes;
}
