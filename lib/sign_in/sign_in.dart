
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../home/dashboard.dart';
import '../model/login_model.dart';
import '../preferences/pref_repository.dart';
import '../repository/api_helper.dart';
import '../utils/common.dart';
import '../utils/common_widget/default_button.dart';
import '../utils/constant/const_color.dart';
import '../utils/constant/constants.dart';

class SigninScreen extends StatefulWidget {
  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

 // final siginInController = Get.put(SigninPageController());
 // late WidgetsCollection _widgets;

  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();
  bool showpassword = true;
  final _prefRepo = PrefRepository();
 String ? mytoken;
  @override
  void initState() {
    super.initState();
  }

  Future<void> login() async {
    // int amo= int.parse(amount);
    EasyLoading.show(status: 'loading...');

    await FirebaseMessaging.instance.getToken().then((token) {
      debugPrint("device Token :$token");
       mytoken = token;
    });

    Map<String, dynamic> data = {
      "user_id":username.text,
      "password":password.text,
      "fcm_token":mytoken,
    //    memberId
    };


    ApiHelper apiHelper = ApiHelper();
    await apiHelper.post(
        api: "https://lightsgallery.in/apps/public/api/login",
        body: data,
        onSuccess: ({required response}) async {

          Map<String, dynamic> obj = jsonDecode(response.body);
          print(obj.toString());
          var successresp = LoginModel.fromJson(obj);

          print(successresp.meta!.status);
          EasyLoading.dismiss();

          if(successresp.meta!.status! == "fail"){
            showSnackbar(successresp.meta!.message!);
          }
          else{

            _prefRepo.saveLoginData(successresp);

            Get.offAll(DashboardScreen());

          }

    // homeController.coin();
        //  Navigator.pop(context);



        },
        onFailure: ({required message}) {
          EasyLoading.dismiss();

          print('falied');
          /// Navigator.pop(context);
        });
  }


  @override
  Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: backgroundcolor1,
        body: SafeArea(
            child: SingleChildScrollView(
                child: Container(

                    color: backgroundcolor1,
                    margin: EdgeInsets.only(left: 20, right: 20),
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 40,
                        ),
                        Center(
                            child: Image.asset(
                          constImage.splashImage,
                              width: MediaQuery.of(context).size.width/2,
                        )),
                        SizedBox(
                          height: 50,
                        ),
                        /*Center(
                            child: Text(
                          constString.emailPass,
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: primaryColor1),
                        )),
                        SizedBox(
                          height: 30,
                        ),*/

                        Text(
                          'Login',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: headercolor),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Form(
                            key: _formkey,
                            autovalidateMode: AutovalidateMode.disabled,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                               /* Text(
                                  constString.email+' *',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: labelcolor,
                                      fontWeight: FontWeight.w400),
                                ),*/
                                SizedBox(height: 2),
                                TextFormField(
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  controller: username,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter username';
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.emailAddress,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: textcolor,
                                      fontWeight: FontWeight.w400),
                                 // controller: siginInController.usernametxtController,
                                  decoration: InputDecoration(

                                      contentPadding: EdgeInsets.all(16),
                                      border: customBorder,
                                      fillColor: white,
                                      filled: true,
                                      labelText: constString.emailAddress,
                                      hintText: constString.emailAddress,
                                      prefixIcon: Icon(
                                        Icons.account_circle,
                                        size: 18,
                                        color: Colors.grey,
                                      ),
                                      hintStyle: TextStyle(
                                          fontSize: 14,
                                          color: labelcolor,
                                          fontWeight: FontWeight.w400),
                                      labelStyle: TextStyle(
                                          fontSize: 14,
                                          color: labelcolor,
                                          fontWeight: FontWeight.w400),
                                      errorBorder: customerrorBorder,
                                      focusedBorder: customfocusBorder,
                                      enabledBorder: customBorder),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                /*Text(
                                  constString.pass+' *',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: labelcolor,
                                      fontWeight: FontWeight.w400),
                                ),
                                SizedBox(height: 2),*/
                                TextFormField(
                                 obscureText: showpassword,
                                //  controller: siginInController.passwordtxtController,
                                  validator: (value) {
                                    if (value!.trim().isEmpty) {
                                      return 'Please enter password';
                                    }
                                    return null;
                                  },
                                  controller: password,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: textcolor,
                                        fontWeight: FontWeight.w400),
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(16),
                                      border: customBorder,
                                      fillColor: white,
                                      filled: true,
                                      hintText: constString.yourPass,
                                      labelText: constString.yourPass,
                                       hintStyle: TextStyle(
                                           fontSize: 14,
                                           color: labelcolor,
                                           fontWeight: FontWeight.w400),
                                      labelStyle: TextStyle(
                                          fontSize: 14,
                                          color: labelcolor,
                                          fontWeight: FontWeight.w400),
                                      suffixIcon: IconButton(
                                          icon: Icon(!showpassword
                                                  ? Icons.visibility:
                                                   Icons.visibility_off,
                                              //change icon based on boolean value
                                              color: Colors.black),
                                          onPressed: () {
                                            //if(showpassword){
                                              showpassword = !showpassword;
                                              setState(() {

                                              });
                                           // }
                                           // siginInController.tooglePassword();
                                          }),
                                      prefixIcon: Icon(
                                        Icons.lock,
                                        size: 18,
                                        color: Colors.grey,
                                      ),
                                      errorBorder: customerrorBorder,
                                      focusedBorder: customfocusBorder,
                                      enabledBorder: customBorder),
                                ),
                               /* SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      constString.forgetpass,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),*/
                                SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                        child: DefaultButton(
                                            press: () {

                                             // Get.to(DashboardScreen());
                                             if (_formkey.currentState!
                                                  .validate()) {
                                               login();
                                                }
                                                /*else{
                                                  showSnackbar(
                                                      constString.acceptTnC);
                                                }*/
                                              },
                                            text: constString.signIn,

                                            height: 48)),
                                  ],
                                ),
                                SizedBox(height: 10),
                               /* Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Checkbox(
                                        side: BorderSide(
                                          color: onboardingButtoncolor,
                                          width: 1.5,
                                        ),
                                        checkColor: Colors.white,
                                        value: siginInController.checkBox,
                                        activeColor: onboardingButtoncolor,
                                        onChanged: (value) {
                                          siginInController.toogleCheckbox();
                                        },
                                      ),
                                      Expanded(child: PrivacyPolicy()),
                                    ])*/
                              ],
                            )),
                      ],
                    )))),
      );
  }
}
