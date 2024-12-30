import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:light_gallery/model/EmployeeModel.dart';
import 'package:light_gallery/project/project_add_task.dart';
import 'package:light_gallery/project/project_update_task.dart';
import 'package:light_gallery/task/update_task.dart';
import 'package:light_gallery/task/widget/task_expanded_tile.dart';

import '../model/ProjectTaskListModel.dart';
import '../model/TaskListModel.dart';
import '../model/login_model.dart';
import '../preferences/pref_repository.dart';
import '../repository/api_helper.dart';
import '../task/widget/project_task_expanded_tile.dart';
import '../utils/common.dart';
import '../utils/common_widget/default_button.dart';
import '../utils/constant/const_color.dart';
import '../utils/constant/constants.dart';

class ProjectTaskListscreen extends StatefulWidget {
  final int projid;

  const ProjectTaskListscreen({super.key, required this.projid});

  @override
  _ProjectTaskListscreen createState() => _ProjectTaskListscreen();
}

class _ProjectTaskListscreen extends State<ProjectTaskListscreen> {
//  final con = Get.put(QuotesPageController());
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  var height, width;
  List<EmpData> empdata = [];
  final _prefRepo = PrefRepository();
  List<ProjectData> taskdata = [];


  int? prevselected ;

  bool repeatspecific = false;

  bool repeatyes = false;

  String? assignto;
  String  repeatto ='';
  String repeatto1 = '';
  String repeatto2 ='';
  String refTasktype ='';

  String? assignid;

  String tasktype = 'Open Task';

  int? loguserId;

  var itemsTask = [
    'Open Task',
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
      cancelText: 'Clear',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: dashtextcolor1, // header background color
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

      getData();

    }
    else{

      datecontroller.clear();

      getData();

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
    EasyLoading.show(status: 'loading...');

    taskdata.clear();
    final profileResponse = await _prefRepo.getLoginUserData();

    loguserId = profileResponse!.data!.id;

    if(tasktype == "Open Task"){
      refTasktype = 'Open';
    }
    else{

      refTasktype = 'Completed';
    }

    Map<String, dynamic> data = {
      "project_id":widget.projid,
      "date":datecontroller.text,
      "status":refTasktype,
      "id":loguserId
      //    memberId
    };


    ApiHelper apiHelper = ApiHelper();
    await apiHelper.post(
        api: "https://lightsgallery.in/apps/public/api/project-task",
        body: data,
        onSuccess: ({required response}) async {

          Map<String, dynamic> obj = jsonDecode(response.body);
          print(obj.toString());
          var successresp = ProjectTaskListModel.fromJson(obj);

          print(successresp.meta!.status);
          EasyLoading.dismiss();

          if(successresp.meta!.status! == "fail"){
           // showSnackbar(successresp.meta!.message!);
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
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: backgroundcolor1,
        appBar: AppBar(
            elevation: 1,
            centerTitle: false,
            title: Text(
              "Light's Gallery",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700),
            ),
            /* leading: Image.asset(
              constImage.appIcon,
              width: 24,
              height: 24,
            ),*/
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: primaryColor,
           /* actions: <Widget>[
              Padding(
                  padding: EdgeInsets.only(right: 15.0),
                  child: InkWell(
                      onTap: () {
                        // createDialog(context);
                      },
                      child: Icon(
                        Icons.notifications,
                        color: Colors.white,
                        size: 30,
                      ))),
            ]*/),

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
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          // isExtended: true,
            child: Icon(Icons.add),
            backgroundColor: primaryColor,
            onPressed: () {
              Get.to(ProjectAddTaskscreen(projid: widget.projid,))?.then((value)  {
                getData();
              });
            }),
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
                          height: height/10,
                          color: Colors.white,
                            child:
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(width: 10,),

                                Expanded(child:
                                DropdownButtonFormField<String>(
                                    itemHeight: 50.0,
                                    icon:
                                    const Icon(Icons.keyboard_arrow_down),
                                    value: tasktype,
                                    hint: const Text("Assign To",style: TextStyle(
                                      fontSize: 14,
                                      color: textcolor,
                                      fontWeight: FontWeight.w400,)),
                                    items: itemsTask.map((String items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: Text(items),
                                      );
                                    }).toList(),
                                    /* value:
                                          attendanceController.selectedProject,
                                          items: attendanceController.projectList
                                              .map((ProjectData value) {
                                            return DropdownMenuItem<String>(
                                              value: value.text,
                                              child: Text(value.text!),
                                            );
                                          }).toList(),*/
                                    onChanged: (newValue) {
                                      /* attendanceController
                                                .updateProject(newValue!);*/

                                      tasktype = newValue!;
                                      setState(() {

                                      });

                                      getData();
                                     /* empdata.forEach((element) {
                                        if (element.fullName == newValue) {
                                          assignid = element.uId!;
                                        }
                                      });*/

                                    },
                                    validator: (value) => value == null
                                        ? constString.errorField

                                        : null,
                                    decoration: InputDecoration(
                                        errorBorder: customerrorBorder,
                                        focusedBorder: customfocusBorder,
                                        enabledBorder: customBorder,
                                        filled: true,
                                        fillColor: Colors.white,
                                        isDense: true))),
                               SizedBox(width: 10,),
                                /*Expanded(child:
                                GestureDetector(
                                    onTap: () {
                                      _selectDate(context);
                                    },
                                    child:
                                    TextFormField(
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      controller: datecontroller,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return constString.errorField;
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
                                          suffixIcon: IconButton(
                                              icon: Icon(*//*siginInController.togggle
                                                  ? Icons.visibility*//*
                                                  Icons.date_range,
                                                  //change icon based on boolean value
                                                  color: Colors.black),
                                              onPressed: () {
                                                // siginInController.tooglePassword();
                                              }),
                                          contentPadding: EdgeInsets.all(16),
                                          border: customBorder,
                                          fillColor: white,
                                          filled: true,
                                          enabled: false,
                                          labelText: "Due date *",
                                          hintText: "Select date",
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
                                    ))),
                                SizedBox(width: 10,),*/


                              ],)),
                            SizedBox(
                              height: 20,
                            ),
                        taskdata.length > 0?
                            Expanded(child:
                            ListView.builder(
                              shrinkWrap: true,

                              scrollDirection: Axis.vertical,
                              itemCount: taskdata.length,
                              itemBuilder: (context, index) {
                                return ProjectTaskExpandedTile(
                                  userid: loguserId ?? 0,
                                  quotesResults: taskdata[index],
                                  date: taskdata[index].date!,
                                  Index: index,
                                  onpress1: (int mainindex,int subindex){

                                    print(mainindex);
                                    print(subindex);

                                    Get.to(ProjectUpdateTaskscreen(tasks:taskdata[index],maindate:taskdata[index].date!))?.then((value) {
                                      getData();

                                    });

                                  },
                                  /*onpress: (){
                                    con.deleteAccessories(con.assignData[index].assignAccessoriesId!);
                                  },
                                  onAccept: (){

                                    String currentDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
                                    final format = DateFormat("dd-MM-yyyy");
                                    DateTime gettingDate = format.parse(con.assignData[index].strDate.toString());
                                    print(gettingDate);
                                    String dateFormate = DateFormat("yyyy-MM-dd").format(gettingDate);

                                    String otpdate = dateFormate +' '+con.assignData[index].insertedTime.toString();
                                    print(otpdate);
                                    print(currentDate);

                                    DateTime dt1 = DateTime.parse(currentDate);
                                    DateTime dt2 = DateTime.parse(otpdate);
                                    Duration diff = dt1.difference(dt2);

                                    con.createDialog(context,con.assignData[index].assignAccessoriesId!,con.assignData[index].oTP!,diff.inHours);


                                  },*/
                                );
                              },
                            )



                            ): Center(
                            child:
                            Container(
                                width: width,
                                height: width/2,
                                decoration: new BoxDecoration(
                                    image: new DecorationImage(
                                      fit: BoxFit.cover,
                                      image: new AssetImage(constImage.notaskImage),
                                    )))),
                              taskdata.length > 0?SizedBox.shrink():
                              SizedBox(height: 20,),
                              taskdata.length > 0?SizedBox.shrink():
                        Center(child:
                              Text(
                                'No tasks yet',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: headercolor)),
                              ),


                          ],
                        )))

        ));
  }
}
