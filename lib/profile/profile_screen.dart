import 'dart:convert';
import 'dart:io';

import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:light_gallery/model/EmployeeModel.dart';
import 'package:light_gallery/task/add_task.dart';
import 'package:light_gallery/task/update_task.dart';
import 'package:light_gallery/task/widget/task_expanded_tile.dart';

import '../model/DashboardModel.dart';
import '../model/TaskListModel.dart';
import '../model/login_model.dart';
import '../preferences/pref_repository.dart';
import '../repository/api_helper.dart';
import '../sign_in/sign_in.dart';
import '../utils/common.dart';
import '../utils/common_widget/default_button.dart';
import '../utils/common_widget/default_button1.dart';
import '../utils/constant/const_color.dart';
import '../utils/constant/constants.dart';

class Profilescreen extends StatefulWidget {
  @override
  _Profilescreen createState() => _Profilescreen();
}

class _Profilescreen extends State<Profilescreen> {
//  final con = Get.put(QuotesPageController());
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  var height, width;
  List<EmpData> empdata = [];
  final _prefRepo = PrefRepository();
  DashData? taskdata ;


  int? prevselected ;

  bool repeatspecific = false;

  bool repeatyes = false;

  String? assignto;
  String  name ='';
  String email = '';
  String mobile ='';
  String desg ='';
  String proid ='';

  String? image ;

  String? assignid;

  String tasktype = 'All Task';



  var itemsTask = [
    'All Task',
    'My Task',
    'Assigned Task',
    'Received Task',
    'Completed Task'
  ];

  var repeattype = [
    'Everyday',
    'Specific day',
  ];

  var Everyday = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];

  final List<Map<String, dynamic>> pro = [
      {
  "LABEL": "High",
  "selected": false,
    },
    {
      "LABEL": "Medium",
      "selected": false,
    },
    {
      "LABEL": "Low",
      "selected": false,
    },
    ];


  final TextEditingController taskcontroller = TextEditingController();
  final TextEditingController desccontroller = TextEditingController();
  final TextEditingController datecontroller = TextEditingController();
  final TextEditingController timecontroller = TextEditingController();


  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900, 1),
      lastDate: DateTime(2030,1),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.white, // header background color
              onPrimary: Colors.black, // header text color
              onSurface: Colors.black, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      final String formatted = formatter.format(picked);

      datecontroller.text= formatted;


    }
  }

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(), builder: (BuildContext context,  child) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
        child: child!,
      );});

    print(picked?.format(context));
    if (picked != null) {


      timecontroller.text = picked!.format(context);
    }


  }

  Future<void> getData() async {
    // int amo= int.parse(amount);

    final profileResponse = await _prefRepo.getLoginUserData();

    name = profileResponse!.data!.fullName.toString();
    email = profileResponse!.data!.email.toString();
    mobile = profileResponse!.data!.mobileNo!.toString();
    desg = profileResponse!.data!.designation.toString();
    image = profileResponse!.data!.image.toString();
    proid = profileResponse!.data!.uId.toString();


    setState(() {

    });

  }


  Future<void> Logout() async {
    // int amo= int.parse(amount);
    EasyLoading.show(status: 'loading...');

    Map<String, dynamic> data = {
      //    memberId
    };

    final profileResponse = await _prefRepo.getLoginUserData();


    ApiHelper apiHelper = ApiHelper();
    await apiHelper.get(
        api: "https://lightsgallery.in/apps/public/api/employees/logout/" +
            profileResponse!.data!.id.toString(),
        onSuccess: ({required response}) async {
          Map<String, dynamic> obj = jsonDecode(response.body);
          print(obj.toString());
          var successresp = LoginModel.fromJson(obj);

          print(successresp.meta!.status);
          EasyLoading.dismiss();

          if (successresp.meta!.status! == "fail") {
            showSnackbar(successresp.meta!.message!);
          } else {
            await _prefRepo.clearPreferences();
            Get.offAll(SigninScreen());
            showSnackbar(successresp.meta!.message!);

            // Get.offAll(DashboardScreen());

            /*_prefRepo.saveLoginData(successresp);

            Get.to(DashboardScreen());*/
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
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: backgroundcolor1,
        body: SafeArea(
            child:
                 Container(
                    width: width,
                    color: backgroundcolor1,
                    child: Padding(
                        padding: EdgeInsets.only(left: 0, right: 0),
                        child:
                          Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,

                            children: [


                              SizedBox(height: 20,),

                          Container(
                          width: width,
                          color: Colors.white,
                            child:Column(children: [

                              SizedBox(height: 10,),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(width: 10,),

                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Container(
                                    height: 80,
                                    width: 80,

                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black,
                                    ),
                                    clipBehavior: Clip.hardEdge,
                                    child: Image.network(
                                      "${image}",
                                      fit: BoxFit.cover,
                                      filterQuality: FilterQuality.high,
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                  SizedBox(height: 20,),

                                Text(
                                  name +' [$proid]',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: headercolor),
                                ),
                                  Text(
                                    mobile,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: labelcolor),
                                  ),
                                  Text(
                                    email,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: labelcolor),
                                  ),
                                  Text(
                                    desg,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: labelcolor),
                                  ),

                                SizedBox(width: 30,),

                                ],)
                              ],),

                            ],)),
                              SizedBox(height: 20,),

                              Container(
                                  width: width,
                                  color: Colors.white,
                                  child:Column(children: [

                                    SizedBox(height: 10,),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(width: 22,),

                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [

                                          SizedBox(height: 20,),

                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [

                                          Icon(Icons.headset_mic_rounded,size: 20,color: iconcolor2),
                                            SizedBox(width: 5,),

                                            Text(
                                            'Need Help?',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,

                                                color: headercolor),
                                          ),

                                             // Spacer(),
                                              SizedBox(width: width/3,),
                                             SizedBox(width: 100,height: 33,
                                             child:
                                             DefaultButton1(
                                               press: () {
                                                 // deleteTask();
                                               },
                                               text: "CALL NOW",
                                               height: 48,
                                               background: primaryColor,
                                               textcolor: Colors.white,
                                             )
                                             ),
                                             /* Expanded(
                                                  child: DefaultButton1(
                                                    press: () {
                                                     // deleteTask();
                                                    },
                                                    text: "Delete",
                                                    height: 48,
                                                    background: textonecolor,
                                                    textcolor: Colors.white,
                                                  )),*/
                                          ],),


                                              Text(
                                                'If you need support, click to call now \nto speak with an administrator',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    color: labelcolor),
                                              ),

                                          SizedBox(width: 15,height: 30,),

                                        ],),



                                      ],),

                                  ],)),
                              SizedBox(height: 20,),

                              Container(
                                  width: width,
                                  color: Colors.white,
                                  child:Column(children: [

                                    SizedBox(height: 10,),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(width: 22,),

                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [

                                            SizedBox(height: 10,),

                                            InkWell(onTap: ()  {
                                              Logout();
                                            },child:
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [

                                                Icon(Icons.logout,size: 21,color: iconcolor2),
                                                SizedBox(width: 5,),

                                                Text(
                                                  'Logout',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w600,
                                                      color: textcolor),
                                                ),


                                          ],)),
                                            SizedBox(height: 20,),



                                      ],),

                                  ])],

                        ))

        ])))));
  }
}
