import 'dart:convert';
import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:light_gallery/model/EmployeeModel.dart';

import '../home/dashboard.dart';
import '../model/TaskListModel.dart';
import '../model/login_model.dart';
import '../preferences/pref_repository.dart';
import '../repository/api_helper.dart';
import '../utils/common.dart';
import '../utils/common_widget/default_button.dart';
import '../utils/common_widget/default_button1.dart';
import '../utils/constant/const_color.dart';
import '../utils/constant/constants.dart';

class UpdateTaskscreen extends StatefulWidget {
  final Tasks tasks;
  final String maindate;

  const UpdateTaskscreen({super.key, required this.tasks, required this.maindate});

  @override
  _UpdateTaskscreen createState() => _UpdateTaskscreen();
}

class _UpdateTaskscreen extends State<UpdateTaskscreen> {
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

  String? assignid;

  bool completeStatus = false;

  bool taskOwner = false;

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
              primary: dashtextcolor1, // header background color
              onPrimary: Colors.black, // header text color
              onSurface: Colors.black,  // body text color
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


            // _prefRepo.saveLoginData(successresp);

            // Get.to(DashboardScreen());

            taskcontroller.text = widget.tasks.title.toString();
            desccontroller.text = widget.tasks.description.toString();

            String date = widget.tasks.dueDate.toString();
            final dateList = date.split(" ");

            datecontroller.text = dateList[0];
            if (dateList.length > 1) {
              duetimecontroller.text = dateList[1];
            }
            if (dateList.length > 2) {
              duetimecontroller.text = dateList[1] + ' ' + dateList[2];
            }

              print(profileResponse?.data?.id.toString());
            // assignto = widget.tasks.assignedTo!;


            if (widget.tasks.createdBy == widget.tasks.assignedid) {
              assignto = 'Self';

              empdata.removeWhere((element) => element.uId.toString() == profileResponse?.data?.id.toString());

              empdata.insert(
                0,
                EmpData(
                    uId: profileResponse?.data?.id.toString(), fullName: 'Self'),
              );
            } /*else if(widget.tasks.assignedid == profileResponse?.data?.id.toString()){
              assignto = 'Self';
            }*/
            else{
          assignto = widget.tasks.assignedTo!;

          }
            empdata.forEach((element) {
              if (element.fullName == widget.tasks.assignedTo) {
                assignid = element.uId.toString();
              }
            });

            repeatto = widget.tasks.repeat.toString();


            if (repeatto == 'Yes') {
              repeatyes = true;
              timecontroller.text = widget.tasks.repeatTime.toString();
              repeatto1 = widget.tasks.repeatType.toString();
            }

            if (repeatto1 == 'Specific day') {
              repeatspecific = true;
              repeatto2 = widget.tasks.specificday.toString();
            }

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

            if(widget.tasks.status != "Completed" && taskOwner == false) {
              var data;
              for (var element in empdata) {
                print(widget.tasks.assignedid);
                print(element.uId.toString());
                if (element.uId.toString() == widget.tasks.assignedid) {
                  data = element;
                }

              }

              empdata.clear();
              empdata.add(data);
              items.clear();
              repeattype.clear();
              Everyday.clear();
              items.add(repeatto);
              repeattype.add(repeatto1);
              Everyday.add(repeatto2);


            }
            else{

              print(widget.tasks.status);

              if(widget.tasks.status == "Completed" && taskOwner == true){
                var data;
                for (var element in empdata) {
                  if (element.fullName == widget.tasks.assignedTo) {
                     data = element;
                  }
                }
                empdata.clear();
                empdata.add(data);
                items.clear();
                repeattype.clear();
                Everyday.clear();
                items.add(repeatto);
                repeattype.add(repeatto1);
                Everyday.add(repeatto2);
              }
              else {
                if (widget.tasks.status == "Completed" && taskOwner == false) {
                  var data;
                  for (var element in empdata) {
                    if (element.uId.toString() == widget.tasks.assignedid) {
                      data = element;
                    }
                  }
                  empdata.clear();
                  empdata.add(data);
                  items.clear();
                  repeattype.clear();
                  Everyday.clear();
                  items.add(repeatto);
                  repeattype.add(repeatto1);
                  Everyday.add(repeatto2);


                }
              }

            }

            //  timecontroller.text = widget.tasks.title.toString();

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

    if (assignid == null) {
      assignid = profileResponse?.data?.id.toString();
    }
    if (repeatto == '') {
      repeatto = 'No';
    }
    if (repeatto == 'No') {
      repeatto2 = '';
      repeatto1 = '';
      timecontroller.text = '';
    }
    if (repeatto == 'Yes' && repeatto1 == 'Everyday') {
      repeatto2 = '';
    }

    Map<String, dynamic> data = {
      "title": taskcontroller.text,
      "description": desccontroller.text,
      "created_by": profileResponse!.data!.id,
      "due_date": '${datecontroller.text}${" "}${duetimecontroller.text}',
      "date": '${datecontroller.text}',
      "assigned_to": assignid,
      "priority": pro[prevselected!]['LABEL'],
      "repeat": repeatto,
      "specificday": repeatto2,
      "repeat_type": repeatto1,
      //  "repeat_time":timecontroller.text,
      "status": widget.tasks.status

      //    memberId
    };

    ApiHelper apiHelper = ApiHelper();
    await apiHelper.post(
        api: "https://lightsgallery.in/apps/public/api/tasks/update/" +
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

    Map<String, dynamic> data = {
      "status": 'Completed',
      "date": widget.maindate
      //    memberId
    };

    ApiHelper apiHelper = ApiHelper();
    await apiHelper.post(
        api:
            "https://lightsgallery.in/apps/public/api/tasks/update_status/" +
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
        api: "https://lightsgallery.in/apps/public/api/tasks/delete/" +
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
        body: SafeArea(
            child: SingleChildScrollView(
                child: Container(
                    width: width,
                    color: backgroundcolor1,
                    child: Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Update Task',
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
                                        enabled:
                                            widget.tasks.status == "Completed" || taskOwner == false
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
                                            labelText: "Task Title *",
                                            hintText: "Enter your full task",
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
                                      //  autovalidateMode: AutovalidateMode.onUserInteraction,
                                        controller: desccontroller,
                                        enabled:
                                            widget.tasks.status == "Completed" || taskOwner == false
                                                ? false
                                                : true,

                                        /*validator: (value) {
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
                                            labelText: "Description *",
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
                                      GestureDetector(
                                          onTap: () {
                                            if (widget.tasks.status == "Completed" || taskOwner == false) {
                                            } else {
                                              _selectDate(context);
                                            }
                                          },
                                          child: TextFormField(
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            controller: datecontroller,
                                            enabled: false,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return constString.errorField;
                                              }
                                              return null;
                                            },
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: textcolor,
                                                fontWeight: FontWeight.w400),

                                            // controller: siginInController.usernametxtController,
                                            decoration: InputDecoration(
                                                suffixIcon: IconButton(
                                                    icon: Icon(
                                                        /*siginInController.togggle
                                                  ? Icons.visibility*/
                                                        Icons.date_range,
                                                        //change icon based on boolean value
                                                        color: Colors.black),
                                                    onPressed: () {
                                                      // siginInController.tooglePassword();
                                                    }),
                                                contentPadding:
                                                    EdgeInsets.all(16),
                                                border: customBorder,
                                                fillColor: white,
                                                filled: true,
                                                enabled: false,
                                                labelText: "Due date *",
                                                hintText: "Select date",
                                                hintStyle: TextStyle(
                                                    fontSize: 14,
                                                    color: labelcolor,
                                                    fontWeight:
                                                        FontWeight.w400),
                                                labelStyle: TextStyle(
                                                    fontSize: 14,
                                                    color: labelcolor,
                                                    fontWeight:
                                                        FontWeight.w400),
                                                errorBorder: customerrorBorder,
                                                focusedBorder:
                                                    customfocusBorder,
                                                enabledBorder: customBorder),
                                          )),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            if (widget.tasks.status ==
                                                "Completed" || taskOwner == false) {
                                            } else {
                                              _selectTime1(context);
                                            }
                                          },
                                          child: TextFormField(
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            controller: duetimecontroller,
                                            enabled: false,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return constString.errorField;
                                              }
                                              return null;
                                            },
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: textcolor,
                                                fontWeight: FontWeight.w400),

                                            // controller: siginInController.usernametxtController,
                                            decoration: InputDecoration(
                                                suffixIcon: IconButton(
                                                    icon: Icon(
                                                        /*siginInController.togggle
                                                  ? Icons.visibility*/
                                                        Icons.timelapse,
                                                        //change icon based on boolean value
                                                        color: Colors.black),
                                                    onPressed: () {
                                                      // siginInController.tooglePassword();
                                                    }),
                                                contentPadding:
                                                    EdgeInsets.all(16),
                                                border: customBorder,
                                                fillColor: white,
                                                filled: true,
                                                enabled: false,
                                                labelText: "Due time *",
                                                hintText: "Select time",
                                                hintStyle: TextStyle(
                                                    fontSize: 14,
                                                    color: labelcolor,
                                                    fontWeight:
                                                        FontWeight.w400),
                                                labelStyle: TextStyle(
                                                    fontSize: 14,
                                                    color: labelcolor,
                                                    fontWeight:
                                                        FontWeight.w400),
                                                errorBorder: customerrorBorder,
                                                focusedBorder:
                                                    customfocusBorder,
                                                enabledBorder: customBorder),
                                          )),
                                      SizedBox(
                                        height: 10,
                                      ),

                                      DropdownSearch<String>(
                                        popupProps: PopupProps.menu(
                                          showSelectedItems: true,
                                          showSearchBox: true,
                                        ),
                                        enabled: widget.tasks.status == "Completed" || taskOwner == false? false:true,
                                        autoValidateMode: AutovalidateMode.always,
                                        validator: (value) => value == null
                                            ? constString.errorField

                                            : null,
                                        items: empdata.map((e)=>e.fullName!).toList(),
                                        dropdownDecoratorProps: DropDownDecoratorProps(
                                          dropdownSearchDecoration: InputDecoration(
                                              labelText: "Assign To",
                                              hintText: "search",
                                              hintStyle: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w400),
                                              errorBorder: customerrorBorder,
                                              focusedBorder: customfocusBorder,
                                              enabledBorder: customBorder,
                                              filled: true,
                                              fillColor: Colors.white,
                                              isDense: true
                                          ),
                                        ),
                                        onChanged: (value) {
                                          if (widget.tasks.status ==
                                              "Completed" || taskOwner == false) {
                                          } else {
                                            empdata.forEach((element) {
                                              if (element.fullName ==
                                                  value) {
                                                assignid =
                                                    element.uId.toString();
                                              }
                                            });
                                            assignto = value!;
                                          }

                                        },
                                        selectedItem: assignto,
                                      ),

/*
                                      DropdownButtonFormField<String>(
                                          itemHeight: 50.0,
                                          icon: const Icon(
                                              Icons.keyboard_arrow_down),
                                          value: assignto,
                                          hint: const Text("Assign",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: textcolor,
                                                fontWeight: FontWeight.w400,
                                              )),
                                          items: empdata.map((EmpData items) {
                                            return DropdownMenuItem(
                                              value: items.fullName,
                                              child: Text(items.fullName!),
                                              enabled: widget.tasks.status == "Completed" || taskOwner == false? false:true,
                                            );
                                          }).toList(),

                                          onChanged: (newValue) {


                                            if (widget.tasks.status ==
                                                "Completed" || taskOwner == false) {
                                            } else {
                                              empdata.forEach((element) {
                                                if (element.fullName ==
                                                    newValue) {
                                                  assignid =
                                                      element.uId.toString();
                                                }
                                              });
                                              assignto = newValue!;
                                            }
                                          },
                                          validator: (value) => value == null
                                              ? constString.errorField
                                              : null,
                                          decoration: InputDecoration(
                                              errorBorder: customerrorBorder,
                                              focusedBorder: customfocusBorder,
                                              enabledBorder: customBorder,
                                              filled: true,
                                              labelText: 'Assign To',
                                              fillColor: Colors.white,
                                              isDense: true)),
*/
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
                                                        if (widget.tasks.status == "Completed" || taskOwner == false) {
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
                                        height: 10,
                                      ),
                                      DropdownButtonFormField<String>(
                                          itemHeight: 50.0,
                                          icon: const Icon(
                                              Icons.keyboard_arrow_down),
                                          value: repeatto,
                                          hint: const Text("Select repeat",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: textcolor,
                                                fontWeight: FontWeight.w400,
                                              )),
                                          items: items.map((String items) {
                                            return DropdownMenuItem(
                                              value: items,
                                              child: Text(items),
                                              enabled: widget.tasks.status == "Completed" || taskOwner == false? false:true,

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
                                            if (widget.tasks.status ==
                                                "Completed" || taskOwner == false) {
                                            } else {
                                              if (newValue == 'Yes') {
                                                repeatyes = true;
                                              } else {
                                                repeatyes = false;
                                                repeatspecific = false;
                                              }
                                              repeatto = newValue!;
                                              setState(() {});
                                            }
                                          },
                                          validator: (value) => value == null
                                              ? constString.errorField
                                              : null,
                                          decoration: InputDecoration(
                                              errorBorder: customerrorBorder,
                                              focusedBorder: customfocusBorder,
                                              enabledBorder: customBorder,
                                              filled: true,
                                              labelText: 'Select repeat',
                                              fillColor: Colors.white,
                                              isDense: true)),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Visibility(
                                          visible: repeatyes,
                                          child: DropdownButtonFormField<
                                                  String>(
                                              itemHeight: 50.0,
                                              icon: const Icon(
                                                  Icons.keyboard_arrow_down),
                                              value:
                                                  repeatto1 ?? 'Specific day',
                                              hint: const Text("Select action",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: textcolor,
                                                    fontWeight: FontWeight.w400,
                                                  )),
                                              items: repeattype
                                                  .map((String items) {
                                                return DropdownMenuItem(
                                                  value: items,
                                                  child: Text(items),
                                                  enabled: widget.tasks.status == "Completed" || taskOwner == false? false:true,
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
                                                if (widget.tasks.status ==
                                                    "Completed" || taskOwner == false) {
                                                } else {
                                                  if (newValue ==
                                                      'Specific day') {
                                                    repeatspecific = true;
                                                  } else {
                                                    repeatspecific = false;
                                                  }
                                                  repeatto1 = newValue!;

                                                  setState(() {});
                                                }
                                              },
                                              validator: (value) =>
                                                  value == null
                                                      ? constString.errorField
                                                      : null,
                                              decoration: InputDecoration(
                                                  errorBorder:
                                                      customerrorBorder,
                                                  focusedBorder:
                                                      customfocusBorder,
                                                  enabledBorder: customBorder,
                                                  filled: true,
                                                  labelText: 'Select action',
                                                  fillColor: Colors.white,
                                                  isDense: true))),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Visibility(
                                          visible: repeatspecific,
                                          child: DropdownButtonFormField<
                                                  String>(
                                              itemHeight: 50.0,
                                              icon: const Icon(
                                                  Icons.keyboard_arrow_down),
                                              value: repeatto2 ?? 'Sunday',
                                              hint: const Text("Select day",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: textcolor,
                                                    fontWeight: FontWeight.w400,
                                                  )),
                                              items:
                                                  Everyday.map((String items) {
                                                return DropdownMenuItem(
                                                  value: items,
                                                  child: Text(items),
                                                  enabled: widget.tasks.status == "Completed" || taskOwner == false? false:true,
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
                                                if (widget.tasks.status ==
                                                    "Completed" || taskOwner == false) {
                                                } else {
                                                  repeatto2 = newValue!;
                                                }
                                              },
                                              validator: (value) =>
                                                  value == null
                                                      ? constString.errorField
                                                      : null,
                                              decoration: InputDecoration(
                                                  errorBorder:
                                                      customerrorBorder,
                                                  focusedBorder:
                                                      customfocusBorder,
                                                  enabledBorder: customBorder,
                                                  filled: true,
                                                  labelText: 'Select day',
                                                  fillColor: Colors.white,
                                                  isDense: true))),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Visibility(
                                          visible: false,
                                          child: GestureDetector(
                                              onTap: () {
                                                if (widget.tasks.status ==
                                                    "Completed" || taskOwner == false) {
                                                } else {
                                                  _selectTime(context);
                                                }
                                              },
                                              child: TextFormField(
                                                autovalidateMode:
                                                    AutovalidateMode
                                                        .onUserInteraction,
                                                controller: timecontroller,
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return constString
                                                        .errorField;
                                                  }
                                                  return null;
                                                },
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: textcolor,
                                                    fontWeight:
                                                        FontWeight.w400),

                                                // controller: siginInController.usernametxtController,
                                                decoration: InputDecoration(
                                                    suffixIcon: IconButton(
                                                        icon: Icon(
                                                            /*siginInController.togggle
                                                  ? Icons.visibility*/
                                                            Icons.timelapse,
                                                            //change icon based on boolean value
                                                            color:
                                                                Colors.black),
                                                        onPressed: () {
                                                          // siginInController.tooglePassword();
                                                        }),
                                                    contentPadding:
                                                        EdgeInsets.all(16),
                                                    border: customBorder,
                                                    fillColor: white,
                                                    filled: true,
                                                    enabled: false,
                                                    labelText: "Add time *",
                                                    hintText: "Select time",
                                                    hintStyle: TextStyle(
                                                        fontSize: 14,
                                                        color: labelcolor,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                    labelStyle: TextStyle(
                                                        fontSize: 14,
                                                        color: labelcolor,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                    errorBorder:
                                                        customerrorBorder,
                                                    focusedBorder:
                                                        customfocusBorder,
                                                    enabledBorder:
                                                        customBorder),
                                              ))),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Visibility(
                                          visible:
                                              widget.tasks.status == "Completed"
                                                  ? false
                                                  : true,
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
                                    visible: taskOwner == true &&
                                        widget.tasks.status ==
                                            "Completed"
                                        ? false
                                        : taskOwner == false
                                        ? false
                                        : true,
                                    child:
                                      Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [

                                              Expanded(
                                                  child: DefaultButton1(
                                                press: () {
                                                  // Get.to(DashboardScreen());
                                                  if (_formkey.currentState!
                                                      .validate()) {
                                                    if (prevselected != null) {
                                                      updateTask();
                                                    } else {
                                                      showSnackbar(
                                                          'select priority');
                                                    }

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
