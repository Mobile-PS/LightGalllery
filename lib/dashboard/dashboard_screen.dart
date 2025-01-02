import 'dart:convert';
import 'dart:io';

import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:light_gallery/model/EmployeeModel.dart';
import 'package:light_gallery/project/add_project.dart';
import 'package:light_gallery/task/add_task.dart';
import 'package:light_gallery/task/update_task.dart';
import 'package:light_gallery/task/widget/task_expanded_tile.dart';

import '../model/DashboardModel.dart';
import '../model/TaskListModel.dart';
import '../model/login_model.dart';
import '../preferences/pref_repository.dart';
import '../repository/api_helper.dart';
import '../utils/common.dart';
import '../utils/common_widget/default_button.dart';
import '../utils/constant/const_color.dart';
import '../utils/constant/constants.dart';

class Dashboardscreen extends StatefulWidget {
  @override
  _Dashboardscreen createState() => _Dashboardscreen();
}

class _Dashboardscreen extends State<Dashboardscreen> {
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
  String  repeatto ='';
  String repeatto1 = '';
  String repeatto2 ='';

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

  Future<void> getData(String? date) async {
    // int amo= int.parse(amount);
    EasyLoading.show(status: 'loading...');



    if(date == null){

      DateTime dateTime = DateTime.now();
      final DateFormat formatter = DateFormat('dd-MM-yyyy');
      final String formatted = formatter.format(dateTime);
      date = formatted;
    }

    final profileResponse = await _prefRepo.getLoginUserData();

    Map<String, dynamic> data = {

      "date":date,
      //    memberId
    };


    ApiHelper apiHelper = ApiHelper();
    await apiHelper.post(
        api: "https://lightsgallery.in/apps/public/api/dashboard/${profileResponse!.data!.id}",
        body: data,
        onSuccess: ({required response}) async {

          Map<String, dynamic> obj = jsonDecode(response.body);
          print(obj.toString());
          var successresp = DashboardModel.fromJson(obj);

          print(successresp.meta!.status);
          EasyLoading.dismiss();

          if(successresp.meta!.status! == "fail"){
            showSnackbar(successresp.meta!.message!);
            setState(() {

            });
          }
          else{

            taskdata = successresp.data!;
           // _prefRepo.saveLoginData(successresp);

           // Get.to(DashboardScreen());

            setState(() {

            });
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
    getData(null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: backgroundcolor1,

      /*  floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
            // isExtended: true,
            child: Icon(Icons.add),
            backgroundColor: primaryColor,
            onPressed: () {
              setState(() {
                //i++;
              });
            }),*/
       /* floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          // isExtended: true,
            child: Icon(Icons.add),
            backgroundColor: primaryColor,
            onPressed: () {
              Get.to(AddTaskscreen())?.then((value)  {
                getData();
              });
            }),*/
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

                            Container(
                            width: width,
                            padding: EdgeInsets.all(10.0),
                            color: Colors.white,
                              child:
                              EasyDateTimeLine(
                                initialDate: DateTime.now(),
                                onDateChange: (selectedDate) {
                                  print(selectedDate);
                                  final DateFormat formatter = DateFormat('dd-MM-yyyy');
                                  final String formatted = formatter.format(selectedDate);
                                  print(formatted);
                                  getData(formatted);

                                  //`selectedDate` the new date selected.
                                },
                                headerProps: const EasyHeaderProps(
                                  selectedDateFormat: SelectedDateFormat.fullDateDMonthAsStrY,
                                  selectedDateStyle: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: headercolor,
                                  ),
                                  monthStyle: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: headercolor,
                                  ),
                                ),
                                dayProps: const EasyDayProps(
                                  height: 56.0,
                                  width: 56.0,
                                  dayStructure: DayStructure.dayStrDayNum,

                                  inactiveDayStyle: DayStyle(
                                    dayNumStyle: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: bordercolor1,
                                    ),
                                    dayStrStyle: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: bordercolor1,
                                    ),
                                  /*  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(8)),
                                      border: Border.all(color: Colors.black12),
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Color(0xffFFF),
                                          Color(0xffFFF),
                                        ],
                                      ),
                                    ),*/
                                  ),
                                  activeDayStyle: DayStyle(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(8)),
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Color(0xff109CF1),
                                          Color(0xff109CF1),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                              SizedBox(height: 20,),

                          Container(
                          width: width,
                          color: Colors.white,
                            child:Column(children: [

                              SizedBox(height: 20,),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(width: 10,),

                                Text(
                                  'Tasks',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: headercolor),
                                ),
                                Spacer(),
                                InkWell(
                                    onTap: () {
                                      Get.to(AddTaskscreen());
                                    },
                                    child:
                                Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Icon(Icons.add,color: dashtextcolor1,),
                                    Text(
                                      'ADD',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: dashtextcolor1,
                                      ),
                                    ),                                  ],
                                )),
                                SizedBox(width: 15,),

                              ],),
                              SizedBox(height: 20,),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(width: 10,),

                                  Container(
                                    width: width/4,
                                    height: height/12,
                                   color: boxback,
                                   child: Column(
                                       crossAxisAlignment: CrossAxisAlignment.center,
                                       mainAxisAlignment: MainAxisAlignment.center,
                                       children: [
                                     Text(
                                       taskdata?.openTask == null? '0':taskdata!.openTask.toString(),
                                       style: TextStyle(
                                         fontSize: 24,
                                         fontWeight: FontWeight.w600,
                                         color: headercolor,
                                       ),
                                     ),
                                         Text(
                                           'Open',
                                           style: TextStyle(
                                             fontSize: 14,
                                             fontWeight: FontWeight.w300,
                                             color: headercolor,
                                           ),
                                         ),
                                   ]),
                                  ),
                                  SizedBox(width: 15,),
                                  Container(
                                    width: width/4,
                                    height: height/12,
                                    color: boxback1,
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            taskdata?.completedTask == null? '0':taskdata!.completedTask.toString(),
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w600,
                                              color: headercolor,
                                            ),
                                          ),
                                          Text(
                                            'Completed',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w300,
                                              color: headercolor,
                                            ),
                                          ),
                                        ]),
                                  ),
                                ],),
                              SizedBox(
                                height: 20,
                              ),
                            ],)),
                              SizedBox(
                                height: 30,
                              ),
                              Container(
                                  width: width,
                                  color: Colors.white,
                                  child:Expanded(child:
                                  Column(children: [

                                    SizedBox(height: 20,),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SizedBox(width: 10,),

                                        Text(
                                          'Project',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                              color: headercolor),
                                        ),
                                        Spacer(),
                                        InkWell(
                                            onTap: () {
                                              Get.to(AddProjectscreen());
                                            },
                                            child:
                                            Wrap(
                                              crossAxisAlignment: WrapCrossAlignment.center,
                                              children: [
                                                Icon(Icons.add,color: dashtextcolor1,),
                                                Text(
                                                  'ADD',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: dashtextcolor1,
                                                  ),
                                                ),                                  ],
                                            )),
                                        SizedBox(width: 15,),

                                      ],),
                                    SizedBox(height: 20,),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        SizedBox(width: 10,),

                                        Container(
                                          width: width/4,
                                          height: height/12,
                                          color: boxback,
                                          child:
                                          Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  taskdata?.open_project == null? '0':taskdata!.open_project.toString(),
                                                  style: TextStyle(
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.w600,
                                                    color: headercolor,
                                                  ),
                                                ),
                                                Text(
                                                  'Open',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w300,
                                                    color: headercolor,
                                                  ),
                                                ),
                                              ]),
                                        ),
                                        SizedBox(width: 15,),
                                        Container(
                                          width: width/4,
                                          height: height/12,
                                          color: boxback1,
                                          child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  taskdata?.completed_project == null? '0':taskdata!.completed_project.toString(),
                                                  style: TextStyle(
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.w600,
                                                    color: headercolor,
                                                  ),
                                                ),
                                                Text(
                                                  'Completed',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w300,
                                                    color: headercolor,
                                                  ),
                                                ),
                                              ]),
                                        ),
                                      ],),
                                    SizedBox(
                                      height: 20,
                                    ),
                                  ],))),
                              SizedBox(
                                height: 10,
                              ),
                              Visibility(
                                  visible: false,
                                  child:
                              Container(
                                  width: width,
                                  color: Colors.white,
                                  child:Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                    SizedBox(height: 20,),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SizedBox(width: 10,),

                                        Text(
                                          'Leads',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                              color: headercolor),
                                        ),
                                        Spacer(),
                                        Wrap(
                                          crossAxisAlignment: WrapCrossAlignment.center,
                                          children: [
                                            Icon(Icons.add,color: dashtextcolor1,),
                                            Text(
                                              'ADD',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: dashtextcolor1,
                                              ),
                                            ),                                  ],
                                        ),
                                        SizedBox(width: 15,),

                                      ],),
                                    SizedBox(height: 20,),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        SizedBox(width: 10,),

                                        Container(
                                          width: width/4,
                                          height: height/12,
                                          color: boxback,
                                          child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  '10',
                                                  style: TextStyle(
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.w600,
                                                    color: headercolor,
                                                  ),
                                                ),
                                                Text(
                                                  'Open',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w300,
                                                    color: headercolor,
                                                  ),
                                                ),
                                              ]),
                                        ),
                                        SizedBox(width: 15,),
                                        Container(
                                          width: width/4,
                                          height: height/12,
                                          color: dashcardcolor1,
                                          child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  '15',
                                                  style: TextStyle(
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.w600,
                                                    color: headercolor,
                                                  ),
                                                ),
                                                Text(
                                                  'Follow_Up',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w300,
                                                    color: headercolor,
                                                  ),
                                                ),
                                              ]),
                                        ),
                                        SizedBox(width: 15,),
                                        Container(
                                          width: width/4,
                                          height: height/12,
                                          color: dashcardcolor2,
                                          child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  '19',
                                                  style: TextStyle(
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.w600,
                                                    color: headercolor,
                                                  ),
                                                ),
                                                Text(
                                                  'Deal',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w300,
                                                    color: headercolor,
                                                  ),
                                                ),
                                              ]),
                                        ),
                                      ],),
                                      SizedBox(
                                        height: 20,
                                      ),
                                    Container(
                                      width: width/4,
                                      height: height/12,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(color: dashbordercolor2)
                                      ),
                                      margin: EdgeInsets.only(left: 10),
                                      child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '8',
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.w600,
                                                color: headercolor,
                                              ),
                                            ),
                                            Text(
                                              'Closed',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w300,
                                                color: headercolor,
                                              ),
                                            ),
                                          ]),
                                    ),

                                    SizedBox(
                                      height: 20,
                                    ),
                                  ],))),

                              SizedBox(
                              height: 40,
                            ),


                          ],
                        )))
            /*Container(
                width: width,
                height: height,
                color: backgroundcolor1,
                child: Padding(
                    padding: EdgeInsets.only(left: 0, right: 0),
                    child:
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,

                      mainAxisSize: MainAxisSize.max,

                      children: [

                        SizedBox(height: width/4,),

                        Center(
                        child:
                    Container(
                    width: width,
                    height: width/2,
                    decoration: new BoxDecoration(
                      image: new DecorationImage(
                        fit: BoxFit.cover,
                        image: new AssetImage(constImage.notaskImage),
                      )))),

                        SizedBox(height: 20,),
                        Text(
                          'No tasks yet',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: headercolor),
                        ),

                      ],
                    )))*/
        ));
  }
}
