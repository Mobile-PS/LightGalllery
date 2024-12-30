import 'dart:convert';
import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:light_gallery/model/EmployeeModel.dart';

import '../home/dashboard.dart';
import '../model/ProjectListModel.dart';
import '../model/TaskListModel.dart';
import '../model/login_model.dart';
import '../preferences/pref_repository.dart';
import '../repository/api_helper.dart';
import '../utils/common.dart';
import '../utils/common_widget/default_button.dart';
import '../utils/common_widget/default_button1.dart';
import '../utils/constant/const_color.dart';
import '../utils/constant/constants.dart';

class UpdateProjectscreen extends StatefulWidget {
  final ProjectData tasks;

  const UpdateProjectscreen({super.key, required this.tasks});

  @override
  _UpdateProjectscreen createState() => _UpdateProjectscreen();
}

class _UpdateProjectscreen extends State<UpdateProjectscreen> {
//  final con = Get.put(QuotesPageController());
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  var height, width;
  List<EmpData> empdata = [];
  final _prefRepo = PrefRepository();

  int? prevselected;

  bool repeatspecific = false;

  bool repeatyes = false;

  String assignto = 'Self';

  String repeatto = 'No';
  String repeatto1 = 'Everyday';
  String repeatto2 = 'Sunday';

  String assignid = '';

  bool completeStatus = false;

  bool taskOwner = false;
  List<String> assign = [];

  var items = [
    'Yes',
    'No',
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
  final TextEditingController duetimecontroller = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900, 1),
      lastDate: DateTime(2030, 1),
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

      datecontroller.text = formatted;
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (BuildContext context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child!,
          );
        });

    print(picked?.format(context));
    if (picked != null) {
      timecontroller.text = picked!.format(context);
    }
  }

  Future<void> _selectTime1(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (BuildContext context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child!,
          );
        });

    print(picked?.format(context));
    if (picked != null) {
      duetimecontroller.text = picked!.format(context);
    }
  }

  Future<void> getData() async {
    // int amo= int.parse(amount);

    final profileResponse = await _prefRepo.getLoginUserData();

    taskcontroller.text = widget.tasks.title.toString();
    desccontroller.text = widget.tasks.description != null && widget.tasks.description.toString() != "null"?widget.tasks.description.toString():'';

    if (widget.tasks.priority == 'High') {
      pro[0]['selected'] = true;

      prevselected = 0;
    } else if (widget.tasks.priority == 'Medium') {
      pro[1]['selected'] = true;

      prevselected = 1;
    } else if (widget.tasks.priority == 'Low') {
      pro[2]['selected'] = true;

      prevselected = 2;
    }

    if (profileResponse?.data?.id.toString() ==
        widget.tasks.createdBy.toString()) {
      taskOwner = true;
    }

    setState(() {});
  }

  Future<void> getData1() async {
    // int amo= int.parse(amount);
    EasyLoading.show(status: 'loading...');

    Map<String, dynamic> data = {
      //    memberId
    };

    final profileResponse = await _prefRepo.getLoginUserData();

    ApiHelper apiHelper = ApiHelper();
    await apiHelper.get(
        api: "https://lightsgallery.in/apps/public/api/employees",
        body: data,
        onSuccess: ({required response}) async {
          Map<String, dynamic> obj = jsonDecode(response.body);
          print(obj.toString());
          var successresp = EmployeeModel.fromJson(obj);

          print(successresp.meta!.status);
          EasyLoading.dismiss();

          if (successresp.meta!.status! == "fail") {
            showSnackbar(successresp.meta!.message!);
          } else {
            empdata = successresp.data!;
            empdata.removeWhere((element) =>
                element.uId.toString() == profileResponse?.data?.id.toString());

            /*empdata.insert(
              0,
              EmpData(
                  uId: profileResponse?.data?.id.toString(), fullName: 'Self'),
            );*/

            if(widget.tasks.assign_to != null) {
              final split = widget.tasks.assign_to?.split(',');

              for (int i = 0; i < split!.length; i++) {
                print(split[i]);

                empdata.forEach(
                      (element) {
                    if (element.uId.toString() == split[i]) {
                      assign.add(element.fullName.toString());
                    }
                  },
                );
              }
              print(assign);
            }
            // assign.add("Self");
            // _prefRepo.saveLoginData(successresp);

            // Get.to(DashboardScreen());

            setState(() {});
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

  Future<void> updateTask() async {
    // int amo= int.parse(amount);
    EasyLoading.show(status: 'loading...');

    final profileResponse = await _prefRepo.getLoginUserData();

    assignid = '';
    assign.forEach((action) {
      empdata.forEach((element) {
        if (element.fullName == action) {
          assignid += '${element.uId.toString()},';
        }
      });
    });

    Map<String, dynamic> data = {
      "title": taskcontroller.text,
      "description": desccontroller.text,
      "priority": prevselected != null?pro[prevselected!]['LABEL']:'Low',
     "assigned_to": assignid !=''?assignid.substring(0, assignid.length - 1):'',
      "status": widget.tasks.status

      //    memberId
    };

    ApiHelper apiHelper = ApiHelper();
    await apiHelper.post(
        api: "https://lightsgallery.in/apps/public/api/project/update/" +
            widget.tasks.id.toString(),
        body: data,
        onSuccess: ({required response}) async {
          Map<String, dynamic> obj = jsonDecode(response.body);
          print(obj.toString());
          var successresp = LoginModel.fromJson(obj);

          print(successresp.meta!.status);
          EasyLoading.dismiss();

          if (successresp.meta!.status! == "fail") {
            showSnackbar(successresp.meta!.message!);
          } else {
            Get.back(result: true);

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

  Future<void> updateStatus() async {
    // int amo= int.parse(amount);
    EasyLoading.show(status: 'loading...');

    assignid = '';
    assign.forEach((action) {
      empdata.forEach((element) {
        if (element.fullName == action) {
          assignid += '${element.uId.toString()},';
        }
      });
    });

    Map<String, dynamic> data = {
      "title": taskcontroller.text,
      "description": desccontroller.text,
      "priority": pro[prevselected!]['LABEL'],
      "assigned_to": assignid !=''?assignid.substring(0, assignid.length - 1):'',
      "status": 'Completed'

      //    memberId
    };
    ApiHelper apiHelper = ApiHelper();
    await apiHelper.post(
        api: "https://lightsgallery.in/apps/public/api/project/update/" +
            widget.tasks.id.toString(),
        body: data,
        onSuccess: ({required response}) async {
          Map<String, dynamic> obj = jsonDecode(response.body);
          print(obj.toString());
          var successresp = LoginModel.fromJson(obj);

          print(successresp.meta!.status);
          EasyLoading.dismiss();

          if (successresp.meta!.status! == "fail") {
            showSnackbar(successresp.meta!.message!);
          } else {
            Get.back(result: true);

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

  Future<void> deleteTask() async {
    // int amo= int.parse(amount);
    EasyLoading.show(status: 'loading...');

    Map<String, dynamic> data = {
      //    memberId
    };

    ApiHelper apiHelper = ApiHelper();
    await apiHelper.get(
        api: "https://lightsgallery.in/apps/public/api/project/delete/" +
            widget.tasks.id.toString(),
        body: data,
        onSuccess: ({required response}) async {
          Map<String, dynamic> obj = jsonDecode(response.body);
          print(obj.toString());
          var successresp = LoginModel.fromJson(obj);

          print(successresp.meta!.status);
          EasyLoading.dismiss();

          if (successresp.meta!.status! == "fail") {
            showSnackbar(successresp.meta!.message!);
          } else {
            Get.back(result: true);

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
    getData1();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          centerTitle: false,
          title: Text(
            "Light's Gallery",
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
          ),
          /* leading: Image.asset(
              constImage.appIcon,
              width: 24,
              height: 24,
            ),*/
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: primaryColor,
          /*   actions: <Widget>[
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
            ]*/
        ),
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
        body: SafeArea(
            child: SingleChildScrollView(
                child: Container(
                    width: width,
                    height: height,
                    color: backgroundcolor1,
                    child: Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Update Project',
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextFormField(
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        controller: taskcontroller,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return constString.errorField;
                                          }
                                          return null;
                                        },
                                        enabled: widget.tasks.status ==
                                                    "Completed" /*||
                                                taskOwner == false*/
                                            ? false
                                            : true,
                                        keyboardType:
                                            TextInputType.emailAddress,
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
                                            labelText: "Project Title *",
                                            hintText: "Enter project title",
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
                                        height: 10,
                                      ),
                                      TextFormField(
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        controller: desccontroller,
                                        enabled: widget.tasks.status ==
                                                    "Completed" /*||
                                                taskOwner == false*/
                                            ? false
                                            : true,

                                      /*  validator: (value) {
                                          if (value!.isEmpty) {
                                            return constString.errorField;
                                          }
                                          return null;
                                        },*/
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: textcolor,
                                            fontWeight: FontWeight.w400),
                                        maxLines: 5,

                                        // controller: siginInController.usernametxtController,
                                        decoration: InputDecoration(
                                            contentPadding: EdgeInsets.all(16),
                                            border: customBorder,
                                            fillColor: white,
                                            filled: true,
                                            labelText: "Description",
                                            hintText: "Enter your description",
                                            hintStyle: TextStyle(
                                                fontSize: 14,
                                                color: labelcolor,
                                                fontWeight: FontWeight.w400),
                                            labelStyle: TextStyle(
                                                fontSize: 14,
                                                color: labelcolor,
                                                fontWeight: FontWeight.w400),
                                            isDense: true,
                                            alignLabelWithHint: true,
                                            errorBorder: customerrorBorder,
                                            focusedBorder: customfocusBorder,
                                            enabledBorder: customBorder),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      DropdownSearch<String>.multiSelection(
                                        popupProps:
                                            PopupPropsMultiSelection.menu(
                                          showSelectedItems: true,
                                          showSearchBox: true,
                                        ),
                                        autoValidateMode:
                                            AutovalidateMode.always,
                                        validator: (value) => value == null
                                            ? constString.errorField
                                            : null,
                                        items: empdata
                                            .map((e) => e.fullName!)
                                            .toList(),
                                        dropdownDecoratorProps:
                                            DropDownDecoratorProps(
                                          dropdownSearchDecoration:
                                              InputDecoration(
                                                  labelText: "Assign",
                                                  hintText: "search",
                                                  hintStyle:
                                                      TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                  errorBorder:
                                                      customerrorBorder,
                                                  focusedBorder:
                                                      customfocusBorder,
                                                  enabledBorder: customBorder,
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  isDense: true),
                                        ),
                                        onChanged: (List<String> value) {
                                          print(value);
                                          assign = value;
                                        },
                                        selectedItems:
                                            assign.isNotEmpty ? assign : [],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        width: width,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          color: Colors.white,
                                        ),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                '   Priority',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: labelcolor,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              Expanded(
                                                  child: ListView.builder(
                                                shrinkWrap: true,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: 3,
                                                itemBuilder: (context, index) {
                                                  return InkWell(
                                                      onTap: () {
                                                        if (widget.tasks
                                                                    .status ==
                                                                "Completed" /*||
                                                            taskOwner ==
                                                                false*/) {
                                                        } else {
                                                          if (prevselected !=
                                                              null) {
                                                            pro[prevselected!][
                                                                    'selected'] =
                                                                false;
                                                            /*_menuItemApi[prevselected!]
                                                    ['selected'] = false;*/
                                                          }
                                                          if (prevselected ==
                                                              index) {
                                                            pro[index][
                                                                    'selected'] =
                                                                false;

                                                            /* _menuItemApi[index]
                                                    ['selected'] = false;*/
                                                            prevselected = null;
                                                          } else {
                                                            /*  _menuItemApi[index]
                                                    ['selected'] = true;*/
                                                            pro[index][
                                                                    'selected'] =
                                                                true;

                                                            prevselected =
                                                                index;
                                                          }
                                                          //  await coinToDiamonds(posterUserId,_menuItemApi[index]['COINS']);
                                                          print(
                                                              'this itm is clicked');
                                                          setState(() {});
                                                        }
                                                      },
                                                      child: Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 20,
                                                                  bottom: 20,
                                                                  right: 10,
                                                                  left: 10),
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          7.0),
                                                              border: Border.all(
                                                                  color:
                                                                      bordercolor1),
                                                              color: pro[index][
                                                                          'selected'] ==
                                                                      true
                                                                  ? Colors.red
                                                                      .shade50
                                                                  : Colors
                                                                      .white),
                                                          height: 10,
                                                          child: Row(
                                                            children: [
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              Icon(
                                                                Icons.flag,
                                                                size: 20,
                                                                color: prevselected != null &&
                                                                        prevselected ==
                                                                            index &&
                                                                        prevselected ==
                                                                            0
                                                                    ? Colors.red
                                                                    : prevselected != null &&
                                                                            prevselected ==
                                                                                index &&
                                                                            prevselected ==
                                                                                1
                                                                        ? Colors
                                                                            .yellow
                                                                        : prevselected != null &&
                                                                                prevselected == index &&
                                                                                prevselected == 2
                                                                            ? Colors.green
                                                                            : borderColor,
                                                              ),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              Text(
                                                                pro[index]
                                                                    ['LABEL'],
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    color: pro[index]['selected'] ==
                                                                            true
                                                                        ? Colors
                                                                            .red
                                                                        : bordercolor1,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400),
                                                              ),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                            ],
                                                          )));
                                                },
                                              ))
                                            ]),
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Visibility(
                                          visible: widget.tasks.status ==
                                                      "Completed" &&
                                                  widget.tasks.taskStatus == 0
                                              ? false
                                              : widget.tasks.status ==
                                              "Open" &&
                                              widget.tasks.taskStatus == 0?true:false,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                  child: DefaultButton1(
                                                press: () {
                                                  updateStatus();
                                                },
                                                text: "Mark as Complete",
                                                height: 48,
                                                background: buttonbackcolor1,
                                                textcolor: Colors.white,
                                              )),
                                            ],
                                          )),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Visibility(
                                          visible: /*taskOwner == true &&*/
                                                  widget.tasks.status ==
                                                      "Completed"
                                              ? false
                                             /* : taskOwner == false
                                                  ? false*/
                                                  : true,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Expanded(
                                                  child: DefaultButton1(
                                                press: () {
                                                  // Get.to(DashboardScreen());
                                                  if (_formkey.currentState!
                                                      .validate()) {
                                                    updateTask();

                                                  /*  if (assign.isNotEmpty) {

                                                      if (prevselected !=
                                                          null) {
                                                        updateTask();
                                                      } else {
                                                        showSnackbar(
                                                            'select priority');
                                                      }
                                                    } else {
                                                      showSnackbar(
                                                          'select assign');
                                                    }*/
                                                  }
                                                },
                                                text: "Update",
                                                height: 48,
                                                background: textonecolor,
                                                textcolor: Colors.white,
                                              )),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                  child: DefaultButton1(
                                                press: () {
                                                  if(widget.tasks.taskStatus == 0) {
                                                    deleteTask();
                                                  }
                                                },
                                                text: "Delete",
                                                height: 48,
                                                background: textonecolor,
                                                textcolor: Colors.white,
                                              )),
                                            ],
                                          )),
                                      Visibility(
                                          visible: widget.tasks.status ==
                                              "Completed"
                                              ? true
                                              : false,
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                  child: DefaultButton1(
                                                    press: () {
                                                      deleteTask();
                                                    },
                                                    text: "Delete",
                                                    height: 48,
                                                    background: textonecolor,
                                                    textcolor: Colors.white,
                                                  )),
                                            ],
                                          )),
                                      SizedBox(
                                        height: 20,
                                      )
                                    ]))
                          ],
                        ))))));
  }
}
