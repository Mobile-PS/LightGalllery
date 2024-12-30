import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:light_gallery/model/EmployeeModel.dart';
import 'package:light_gallery/project/project_task_list.dart';
import 'package:light_gallery/project/update_project.dart';
import 'package:light_gallery/task/update_task.dart';
import 'package:light_gallery/task/widget/task_expanded_tile.dart';

import '../model/ProjectListModel.dart';
import '../model/TaskListModel.dart';
import '../model/login_model.dart';
import '../preferences/pref_repository.dart';
import '../repository/api_helper.dart';
import '../utils/common.dart';
import '../utils/common_widget/default_button.dart';
import '../utils/constant/const_color.dart';
import '../utils/constant/constants.dart';
import 'add_project.dart';

class ProjectListscreen extends StatefulWidget {
  @override
  _ProjectListscreen createState() => _ProjectListscreen();
}

class _ProjectListscreen extends State<ProjectListscreen> {
//  final con = Get.put(QuotesPageController());
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  var height, width;
  List<EmpData> empdata = [];
  final _prefRepo = PrefRepository();
  List<ProjectData> projectdata = [];


  int? prevselected ;

  bool repeatspecific = false;

  bool repeatyes = false;

  String? assignto;
  String  repeatto ='';
  String repeatto1 = '';
  String repeatto2 ='';

  String? assignid;

  String tasktype = 'Open Project';
  String tasktype1 = '';

  int? loguserId;

  var itemsTask = [
    'Completed Project',
    'Open Project',
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

    if(tasktype == "Open Project"){
      tasktype1 = "Open";
    }
    else{

      tasktype1 = 'Completed';

    }
    projectdata.clear();
    final profileResponse = await _prefRepo.getLoginUserData();

    loguserId = profileResponse!.data!.id;

    Map<String, dynamic> data = {
      "id":profileResponse!.data!.id,
      "type":tasktype1,
      //    memberId
    };



    ApiHelper apiHelper = ApiHelper();
    await apiHelper.post(
        api: "https://lightsgallery.in/apps/public/api/projects",
        body: data,
        onSuccess: ({required response}) async {

          Map<String, dynamic> obj = jsonDecode(response.body);
          print(obj.toString());
          var successresp = ProjectListModel.fromJson(obj);

          print(successresp.meta!.status);
          EasyLoading.dismiss();

          if(successresp.meta!.status! == "fail"){
           // showSnackbar(successresp.meta!.message!);
            setState(() {

            });
          }
          else{

            projectdata = successresp.data!;
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
              Get.to(AddProjectscreen())?.then((value)  {
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
                                    hint: const Text("All Project",style: TextStyle(
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

                              ],)),
                            SizedBox(
                              height: 20,
                            ),
                        projectdata.length > 0?
                            Expanded(child:
                            ListView.builder(
                              shrinkWrap: true,

                              scrollDirection: Axis.vertical,
                              itemCount: projectdata.length,
                              itemBuilder: (context, index) {
                                return Container(
                                    margin: EdgeInsets.only(left: 0.0,right: 0.0,top: 10),
                                child:
                                InkWell(onTap: () {

                                  Get.to(ProjectTaskListscreen(projid:projectdata[index].id!))?.then((value) {
                                    getData();

                                  });
                                },child:
                                  Card(
                                    clipBehavior: Clip.antiAlias,
                                    elevation: 1.0,
                                    shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[

                                  Padding(
                                    padding:
                                    const EdgeInsets.only(left: 20, right: 20, top: 4, bottom: 2),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Icon(Icons.circle,size: 15,),
                                        SizedBox(width: 5,),
                                        Expanded(child:
                                        Text(
                                          projectdata[index].title.toString(),
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontSize: 16.0, color: textcolor,fontWeight: FontWeight.w500),
                                        )),
                                        Spacer(),
                                        Icon(Icons.flag,size: 21,color: projectdata[index].priority =='High'?Colors.red:projectdata[index].priority =='Medium'?Colors.yellow:Colors.green,),
                                        /* SizedBox(
                width: 4,
              ),*/
                                        /* Flexible(
                child: Container(
                  child: Text(
                    value.toUpperCase(),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14.0, color: Colors.grey),
                  ),
                ),
              )*/
                                      ],
                                    ),
                                  ),

                                  Padding(
                                    padding:
                                    const EdgeInsets.only(left: 20, right: 0, top: 4, bottom: 2),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                         Visibility(
                                            visible: projectdata[index].assign_to_names.toString().isEmpty?false:true,
                                            child:
                                        Icon(Icons.account_circle,size: 15,)),
                                        SizedBox(width: 5,),

                                        Expanded(child:
                                        Text(
                                          projectdata[index].assign_to_names.toString(),
                                          style: TextStyle(fontSize: 14.0, color: textcolor,fontWeight: FontWeight.w400),
                                        )),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(left: 20, right: 20, top: 4, bottom: 2),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                      //  Icon(Icons.account_circle,size: 15,),
                                        SizedBox(width: 5,),

                                        Spacer(),
                                        InkWell(onTap: () {
                                          Get.to(UpdateProjectscreen(tasks:projectdata[index]))?.then((value) {
                                            getData();

                                          });
                                        },child:
                                        Visibility(
                                            visible:true,
                                            child:
                                            Icon(Icons.edit,size: 21,))),

                                        /* SizedBox(
                width: 4,
              ),*/
                                        /* Flexible(
                child: Container(
                  child: Text(
                    value.toUpperCase(),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14.0, color: Colors.grey),
                  ),
                ),
              )*/
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 5,),


                                ]))));


                              },
                            )


                          /*    SizedBox(height: 20,),
                              Text(
                                'No tasks yet',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: headercolor),
                              ),*/
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
                              projectdata.length > 0?SizedBox.shrink():
                              SizedBox(height: 20,),
                              projectdata.length > 0?SizedBox.shrink():
                        Center(child:
                              Text(
                                'No project yet',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: headercolor)),
                              ),
                              /*SizedBox(height: 10,),
                              taskdata.length > 0?SizedBox.shrink():
                              Center(
                                  child:InkWell(onTap: () {
                                    datecontroller.clear();
                                    tasktype = 'All Task';
                                    setState(() {

                                    });
                                    getData();
                                    },child:
                                  Container(
                                      width: 48,
                                      height: 48,
                                      decoration: new BoxDecoration(
                                          image: new DecorationImage(
                                            fit: BoxFit.cover,
                                            image: new AssetImage(constImage.resetImage),
                                          )))))*/

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
