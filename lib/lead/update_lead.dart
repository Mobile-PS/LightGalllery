import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:light_gallery/model/EmployeeModel.dart';

import '../home/dashboard.dart';
import '../model/LeadListModel.dart';
import '../model/login_model.dart';
import '../preferences/pref_repository.dart';
import '../repository/api_helper.dart';
import '../utils/common.dart';
import '../utils/common_widget/default_button.dart';
import '../utils/common_widget/default_button1.dart';
import '../utils/constant/const_color.dart';
import '../utils/constant/constants.dart';

class UpdateLeadscreen extends StatefulWidget {
  final Leads tasks;

  const UpdateLeadscreen({super.key, required this.tasks});

  @override
  _UpdateLeadscreen createState() => _UpdateLeadscreen();
}

class _UpdateLeadscreen extends State<UpdateLeadscreen> {
//  final con = Get.put(QuotesPageController());
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  var height, width;
  List<EmpData> empdata = [];
  final _prefRepo = PrefRepository();


  int? prevselected;

  bool repeatspecific = false;

  bool repeatyes = false;

  String? assignto;
  String repeatto = '';
  String repeatto1 = '';
  String repeatto2 = '';

  String? assignid;
  String? onlydate;
  String leadStatus = "Open";
  String leadSource = "Facebook";

  String select = "1";

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

  var Leadstatus = [
    'Open',
    'Deal',
    'Follow-Up',
    'Close'
  ];

  var Leadsource = [
    'google',
    'Facebook',
    'Social Media',
    'Walk-in',
    'Reference',
    'News Paper Ads',
    'Exhibition',
    'Others'
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


  final TextEditingController namecontroller = TextEditingController();
  final TextEditingController companycontroller = TextEditingController();
  final TextEditingController mobilecontroller = TextEditingController();
  final TextEditingController addresscontroller = TextEditingController();
  final TextEditingController citycontroller = TextEditingController();
  final TextEditingController statecontroller = TextEditingController();
  final TextEditingController pincodecontroller = TextEditingController();
  final TextEditingController notescontroller = TextEditingController();
  final TextEditingController datecontroller = TextEditingController();
  final TextEditingController timecontroller = TextEditingController();
  final TextEditingController duetimecontroller = TextEditingController();
  final TextEditingController commentcontroller = TextEditingController();

  bool taskOwner = false;


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
      onlydate = formatted;
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(), builder: (BuildContext context, child) {
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
        initialTime: TimeOfDay.now(), builder: (BuildContext context, child) {
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

            // taskcontroller.text = widget.tasks.title.toString();
            // desccontroller.text = widget.tasks.description.toString();

            // String date = widget.tasks.dueDate.toString();
            // final dateList = date.split(" ");

            datecontroller.text = widget.tasks.followupDate.toString();
            duetimecontroller.text = widget.tasks.followupTime.toString();

            namecontroller.text = widget.tasks.fullName.toString();
            companycontroller.text = widget.tasks.companyName.toString();
            mobilecontroller.text = widget.tasks.mobileNo.toString();

            leadStatus = widget.tasks.status.toString();
            leadSource = widget.tasks.source.toString();
            addresscontroller.text = widget.tasks.address.toString();
            citycontroller.text = widget.tasks.city.toString();
            statecontroller.text = widget.tasks.state.toString();
            notescontroller.text = widget.tasks.notes.toString();
            pincodecontroller.text = widget.tasks.pincode.toString();

            if (widget.tasks.specifier.toString() == "Specifier") {
              select = "1";
            }
            else {
              select = "2";
            }

          //  final dateList = date.split(" ");
            /* if (dateList.length > 1) {
              duetimecontroller.text = dateList[1];
            }
            if (dateList.length > 2) {
              duetimecontroller.text = dateList[1] + ' ' + dateList[2];
            }*/

            print(profileResponse?.data?.id.toString());
            // assignto = widget.tasks.assignedTo!;


            if (widget.tasks.createdBy == widget.tasks.assignedId) {
              assignto = 'Self';

              empdata.removeWhere((element) =>
              element.uId.toString() == profileResponse?.data?.id.toString());

              empdata.insert(
                0,
                EmpData(
                    uId: profileResponse?.data?.id.toString(),
                    fullName: 'Self'),
              );
            }
            /*else if(widget.tasks.assignedid == profileResponse?.data?.id.toString()){
              assignto = 'Self';
            }*/
            else {
              assignto = widget.tasks.assignedTo!;
            }
            empdata.forEach((element) {
              if (element.fullName == widget.tasks.assignedTo) {
                assignid = element.uId.toString();
              }
            });

            // repeatto = widget.tasks.repeat.toString();


            /* if (repeatto == 'Yes') {
              repeatyes = true;
              timecontroller.text = widget.tasks.repeatTime.toString();
              repeatto1 = widget.tasks.repeatType.toString();
            }

            if (repeatto1 == 'Specific day') {
              repeatspecific = true;
              repeatto2 = widget.tasks.specificday.toString();
            }*/

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

            if(taskOwner == false){

              Leadstatus.clear();
              Leadstatus.add(widget.tasks.status.toString());
              Leadsource.clear();
              Leadsource.add(widget.tasks.source.toString());
            }

            if (widget.tasks.status != "Completed" && taskOwner == false) {
              var data;
              for (var element in empdata) {
                print(widget.tasks.assignedId);
                print(element.uId.toString());
                if (element.uId.toString() == widget.tasks.assignedId) {
                  data = element;
                }
              }

            //  empdata.clear();
            //  empdata.add(data);
              items.clear();
              repeattype.clear();
              Everyday.clear();
              items.add(repeatto);
              repeattype.add(repeatto1);
              Everyday.add(repeatto2);
            }
            else {
              print(widget.tasks.status);

              if (widget.tasks.status == "Completed" && taskOwner == true) {
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
                    if (element.uId.toString() == widget.tasks.assignedId) {
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


    Map<String, dynamic> data = {
      "full_name": namecontroller.text,
      "company_name": companycontroller.text,
      "mobile": mobilecontroller.text,
      "status": leadStatus,
      "source": leadSource,
      "address": addresscontroller.text,
      "city": citycontroller.text,
      "state": statecontroller.text,
      "pincode": pincodecontroller.text,
      "created_by": widget.tasks.createdBy,
      "followup_date": datecontroller.text,
      "followup_time": duetimecontroller.text,
      "assigned_to": assignid,
      "priority": pro[prevselected!]['LABEL'],
      "notes": notescontroller.text,
      "specifier": select == "1" ? 'Specifier' : "Customer",
      "comment":commentcontroller.text,
      // "repeat_time":timecontroller.text,

      //    memberId
    };


    ApiHelper apiHelper = ApiHelper();
    await apiHelper.post(
        api: "https://lightsgallery.in/apps/public/api/leads/update/" +
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
          }
          else {
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
        api: "https://lightsgallery.in/apps/public/api/leads/delete/" +
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


  String getDate(String date){

    // 2022-05-27T00:00:00
    var mydate;
      final dateList = date.split(" ");
     
              mydate = dateList[0];
           

    DateTime parseDate = DateFormat("dd-MM-yyyy").parse(mydate);

    final DateFormat formatter = DateFormat('MMM dd yyyy');
    final String formatted = formatter.format(parseDate);

    return formatted +" | "+dateList[1] + " "+dateList[2];
  }


  @override
  void initState() {
    getData();

  //  datecontroller.text = formatted;
   // onlydate = formatted;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery
        .of(context)
        .size
        .height;
    width = MediaQuery
        .of(context)
        .size
        .width;

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
          /*actions: <Widget>[
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
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Add Lead',
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
                                    Container(
                                    width: width,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Colors.white,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment
                                          .center,
                                      children: [

                                        Expanded(child:
                                        Container(
                                            margin: EdgeInsets.only(top: 20,
                                                bottom: 20,
                                                right: 10,
                                                left: 10),
                                            decoration: select == "1"
                                                ? BoxDecoration(
                                                borderRadius: BorderRadius
                                                    .circular(7.0),
                                                border: Border.all(
                                                    color: primaryColor),
                                                color: primaryColor
                                            )
                                                : BoxDecoration(
                                                borderRadius: BorderRadius
                                                    .circular(7.0),
                                                border: Border.all(
                                                    color: Colors.grey),
                                                color: Colors.white
                                            ),
                                            height: 50,
                                            child: InkWell(onTap: () {
                                              if(taskOwner == true) {
                                                select = "1";
                                                setState(() {

                                                });
                                              }
                                            }, child:
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .center,
                                              children: [
                                                Text(
                                                  'Specifier',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: select == "1"
                                                          ? Colors.white
                                                          : Colors.black26,
                                                      fontWeight: FontWeight
                                                          .w400),
                                                ),
                                                SizedBox(width: 10,),

                                              ],))
                                        )),
                                        SizedBox(
                                          width: 15,
                                        ),

                                        Expanded(child:

                                        Container(
                                            margin: EdgeInsets.only(top: 20,
                                                bottom: 20,
                                                right: 10,
                                                left: 10),
                                            decoration: select == "2"
                                                ? BoxDecoration(
                                                borderRadius: BorderRadius
                                                    .circular(7.0),
                                                border: Border.all(
                                                    color: primaryColor),
                                                color: primaryColor
                                            )
                                                : BoxDecoration(
                                                borderRadius: BorderRadius
                                                    .circular(7.0),
                                                border: Border.all(
                                                    color: Colors.grey),
                                                color: Colors.white
                                            ),
                                            height: 50,
                                            child: InkWell(onTap: () {
                                              if(taskOwner == true) {
                                                select = "2";
                                                setState(() {

                                                });
                                              }
                                            }, child:
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .center,
                                              children: [
                                                Text(
                                                  'Customer',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: select == "2"
                                                          ? Colors.white
                                                          : Colors.black26,
                                                      fontWeight: FontWeight
                                                          .w400),
                                                ),
                                                SizedBox(width: 10,),

                                              ],))
                                        )),
                                      ],)),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  autovalidateMode: AutovalidateMode
                                      .onUserInteraction,
                                  controller: namecontroller,
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
                                      labelText: "Full Name *",
                                      hintText: "Enter your full name",
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
                                  controller: companycontroller,
                                 /* validator: (value) {
                                    if (value!.isEmpty) {
                                      return constString.errorField;
                                    }
                                    return null;
                                  },*/
                                  enabled:
                                  widget.tasks.status == "Completed" || taskOwner == false
                                      ? false
                                      : true,
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
                                      labelText: "Company Name *",
                                      hintText: "Enter your Company name",
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
                                  autovalidateMode: AutovalidateMode
                                      .onUserInteraction,
                                  controller: mobilecontroller,
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
                                  keyboardType: TextInputType.number,
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
                                      labelText: "Mobile Number *",
                                      hintText: "Enter your mobile number",
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
                                DropdownButtonFormField<String>(
                                    itemHeight: 50.0,
                                    icon:
                                    const Icon(Icons.keyboard_arrow_down),
                                    value: leadStatus,
                                    hint: const Text(
                                        "Lead Status", style: TextStyle(
                                      fontSize: 14,
                                      color: textcolor,
                                      fontWeight: FontWeight.w400,)),
                                    items: Leadstatus.map((String items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: Text(items),
                                        enabled:
                                        widget.tasks.status == "Completed" || taskOwner == false
                                            ? false
                                            : true,
                                      );
                                    }).toList(),

                                    onChanged: (newValue) {
                                      /* attendanceController
                                                .updateProject(newValue!);*/

                                      leadStatus = newValue!;
                                    },
                                    validator: (value) =>
                                    value == null
                                        ? constString.errorField

                                        : null,
                                    decoration: InputDecoration(
                                        errorBorder: customerrorBorder,
                                        focusedBorder: customfocusBorder,
                                        enabledBorder: customBorder,
                                        filled: true,
                                        labelText: 'Lead Status',
                                        fillColor: Colors.white,
                                        isDense: true)),
                                SizedBox(
                                  height: 10,
                                ),
                                DropdownButtonFormField<String>(
                                    itemHeight: 50.0,
                                    icon:
                                    const Icon(Icons.keyboard_arrow_down),
                                    value: leadSource,
                                    hint: const Text(
                                        "Lead Source", style: TextStyle(
                                      fontSize: 14,
                                      color: textcolor,
                                      fontWeight: FontWeight.w400,)),
                                    items: Leadsource.map((String items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: Text(items),
                                        enabled:
                                        widget.tasks.status == "Completed" || taskOwner == false
                                            ? false
                                            : true,
                                      );
                                    }).toList(),

                                    onChanged: (newValue) {
                                      /* attendanceController
                                                .updateProject(newValue!);*/

                                      leadSource = newValue!;
                                    },
                                    validator: (value) =>
                                    value == null
                                        ? constString.errorField

                                        : null,
                                    decoration: InputDecoration(
                                        errorBorder: customerrorBorder,
                                        focusedBorder: customfocusBorder,
                                        enabledBorder: customBorder,
                                        filled: true,
                                        labelText: 'Lead Source',
                                        fillColor: Colors.white,
                                        isDense: true)),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                 // autovalidateMode: AutovalidateMode.onUserInteraction,
                                  controller: addresscontroller,

                                  /*validator: (value) {
                                    if (value!.isEmpty) {
                                      return constString.errorField;
                                    }
                                    return null;
                                  },*/
                                  keyboardType: TextInputType.emailAddress,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: textcolor,
                                      fontWeight: FontWeight.w400),
                                  maxLines: 5,
                                  enabled:
                                  widget.tasks.status == "Completed" || taskOwner == false
                                      ? false
                                      : true,
                                  // controller: siginInController.usernametxtController,
                                  decoration: InputDecoration(

                                      contentPadding: EdgeInsets.all(16),
                                      border: customBorder,
                                      fillColor: white,
                                      filled: true,
                                      labelText: "Address",
                                      hintText: "Enter your address",
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceEvenly,
                                  children: [
                                    Expanded(child:
                                    TextFormField(
                                      autovalidateMode: AutovalidateMode
                                          .onUserInteraction,
                                      controller: citycontroller,
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
                                          labelText: "City*",
                                          hintText: "Enter your city",
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
                                    )),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(child:
                                    TextFormField(
                                      autovalidateMode: AutovalidateMode
                                          .onUserInteraction,
                                      controller: statecontroller,
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
                                      enabled:
                                      widget.tasks.status == "Completed" || taskOwner == false
                                          ? false
                                          : true,
                                      // controller: siginInController.usernametxtController,
                                      decoration: InputDecoration(

                                          contentPadding: EdgeInsets.all(16),
                                          border: customBorder,
                                          fillColor: white,
                                          filled: true,
                                          labelText: "State *",
                                          hintText: "Enter your State",
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
                                    )),

                                  ],),
                                SizedBox(
                                  height: 10,
                                ),
                                /*TextFormField(
                                  autovalidateMode: AutovalidateMode
                                      .onUserInteraction,
                                  controller: pincodecontroller,

                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return constString.errorField;
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.number,
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
                                      labelText: "Pincode *",
                                      hintText: "Enter your pincode",
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
                                ),*/
                                GestureDetector(
                                    onTap: () {
                                      if(taskOwner == true) {
                                        _selectDate(context);
                                      }
                                    },
                                    child:
                                    TextFormField(
                                      autovalidateMode: AutovalidateMode
                                          .onUserInteraction,
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
                                              icon: Icon(/*siginInController.togggle
                                                  ? Icons.visibility*/
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
                                          labelText: "Add date *",
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
                                    )),
                                SizedBox(
                                  height: 10,
                                ),


                                GestureDetector(
                                    onTap: () {
                                      if(taskOwner == true) {
                                        _selectTime1(context);
                                      }
                                    },
                                    child:
                                    TextFormField(
                                      autovalidateMode: AutovalidateMode
                                          .onUserInteraction,
                                      controller: duetimecontroller,
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
                                              icon: Icon(/*siginInController.togggle
                                                  ? Icons.visibility*/
                                                  Icons.timelapse,
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
                                          labelText: "Add time *",
                                          hintText: "Select time",
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
                                    )),
                                SizedBox(
                                  height: 10,
                                ),
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
                                        enabled: widget.tasks.status ==
                                            "Completed"
                                            ? false
                                            : true,
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
                                          "Completed" ) {

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
                                    validator: (value) =>
                                    value == null
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
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                 // autovalidateMode: AutovalidateMode.onUserInteraction,
                                  controller: notescontroller,

                                 /* validator: (value) {
                                    if (value!.isEmpty) {
                                      return constString.errorField;
                                    }
                                    return null;
                                  },*/
                                  keyboardType: TextInputType.emailAddress,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: textcolor,
                                      fontWeight: FontWeight.w400),
                                  maxLines: 5,
                                  enabled:
                                  widget.tasks.status == "Completed" || taskOwner == false
                                      ? false
                                      : true,
                                  // controller: siginInController.usernametxtController,
                                  decoration: InputDecoration(

                                      contentPadding: EdgeInsets.all(16),
                                      border: customBorder,
                                      fillColor: white,
                                      filled: true,
                                      labelText: "Notes",
                                      hintText: "Enter your notes",
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

                                Container(
                                  width: width,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.white,
                                  ),
                                  child:
                                  Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [
                                        SizedBox(height: 10,),
                                        Text(
                                          '   Priority *',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: labelcolor,
                                              fontWeight: FontWeight.w400),
                                        ), Expanded(child:
                                        ListView.builder(
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemCount: 3,
                                          itemBuilder: (context, index) {
                                            return InkWell(onTap: () {
                                              if(taskOwner == true) {
                                                if (prevselected != null) {
                                                  pro[prevselected!]['selected'] =
                                                  false;
                                                  /*_menuItemApi[prevselected!]
                                                    ['selected'] = false;*/
                                                }
                                                if (prevselected == index) {
                                                  pro[index]['selected'] =
                                                  false;

                                                  /* _menuItemApi[index]
                                                    ['selected'] = false;*/
                                                  prevselected = null;
                                                } else {
                                                  /*  _menuItemApi[index]
                                                    ['selected'] = true;*/
                                                  pro[index]['selected'] = true;

                                                  prevselected = index;
                                                }
                                                //  await coinToDiamonds(posterUserId,_menuItemApi[index]['COINS']);
                                                print('this itm is clicked');
                                                setState(() {});
                                              }
                                            }, child:
                                            Container(
                                                margin: EdgeInsets.only(top: 20,
                                                    bottom: 20,
                                                    right: 10,
                                                    left: 10),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius
                                                        .circular(7.0),
                                                    border: Border.all(
                                                        color: bordercolor1),
                                                    color: pro[index]['selected'] ==
                                                        true ? Colors.red
                                                        .shade50 : Colors.white
                                                ),
                                                height: 10,
                                                child: Row(children: [
                                                  SizedBox(width: 10,),
                                                  Icon(Icons.flag, size: 20,
                                                    color: prevselected !=
                                                        null &&
                                                        prevselected == index &&
                                                        prevselected == 0 ?
                                                    Colors.red : prevselected !=
                                                        null &&
                                                        prevselected == index &&
                                                        prevselected == 1
                                                        ? Colors.yellow
                                                        :
                                                    prevselected != null &&
                                                        prevselected == index &&
                                                        prevselected == 2
                                                        ? Colors.green
                                                        : borderColor,),
                                                  SizedBox(width: 10,),
                                                  Text(
                                                    pro[index]['LABEL'],
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: pro[index]['selected'] ==
                                                            true
                                                            ? Colors.red
                                                            : bordercolor1,
                                                        fontWeight: FontWeight
                                                            .w400),
                                                  ),
                                                  SizedBox(width: 10,),

                                                ],)
                                            ));
                                          },
                                        ))
                                      ]),),

                                Container(
                                    width: width,
                                    height: 300,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Colors.white,
                                    ),
                                    child:
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [
                                      SizedBox(height: 10,),
                                    TextFormField(
                                      // autovalidateMode: AutovalidateMode.onUserInteraction,
                                      controller: commentcontroller,

                                      keyboardType: TextInputType.emailAddress,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: textcolor,
                                          fontWeight: FontWeight.w400),
                                      maxLines: 5,

                                      // controller: siginInController.usernametxtController,
                                      decoration: InputDecoration(
                                          suffixIcon: Padding(padding: EdgeInsets.only(top: 70.0),child:IconButton(
                                            onPressed: () {
                                              if (commentcontroller.text.isNotEmpty) {
                                                updateTask();
                                              } else {
                                                showSnackbar(
                                                    'please add comment');
                                              }
                                            },
                                            icon: Icon(Icons.send),
                                          )),
                                          contentPadding: EdgeInsets.all(16),
                                          border: customBorder,
                                          fillColor: white,
                                          filled: true,
                                          labelText: "Comment",
                                          hintText: "Write Comment",
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
                                    ), Expanded(child:
                                ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount: widget.tasks.records?.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                          margin: EdgeInsets.only(left: 20.0,right: 20.0,top: 10),
                                      child:
                                      Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                          Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.account_circle,
                                              size: 15,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                                child: Text(
                                                  widget.tasks.records![index].empName.toString(),
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      color: textcolor,
                                                      fontWeight: FontWeight.w500),
                                                )),]),
                                          Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SizedBox(width: 20,),
                                        Text(
                                          getDate(widget.tasks.records![index].datetime.toString()),
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 12.0,
                                              color: textcolor,
                                              fontWeight: FontWeight.w400),
                                        )]),
                                        SizedBox(height: 5.0,),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              SizedBox(width: 20,),
                                              Expanded(child:
                                              Text(
                                                widget.tasks.records![index].comment.toString(),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 10,
                                                style: TextStyle(
                                                    fontSize: 14.0,
                                                    color: textcolor,
                                                    fontWeight: FontWeight.w400),
                                              ))]),
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                left: 0, right: 0, top: 5.0, bottom: 5.0),
                                            child: Divider(color: Colors.black12))

                                      ]));
                                    })


                                )])),
                            SizedBox(
                              height: 30,
                            ),
                            /*   Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                              child: DefaultButton(
                                                  press: () {

                                                   // Get.to(DashboardScreen());
                                                     if (_formkey.currentState!
                                                  .validate()) {
                if (prevselected != null) {
                  createTask();
                }
                else{

                  showSnackbar('select priority');

                }
                                               */ /* if (siginInController
                                                    .checkBox) {
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                  siginInController
                                                      .signinVerification();
                                                }
                                                else{
                                                  showSnackbar(
                                                      constString.acceptTnC);
                                                }*/ /*
                                              }
                                                  },
                                                  text: "Save",

                                                  height: 48)),

                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),*/

                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Visibility(
                                      visible: taskOwner == true &&
                                          widget.tasks.status ==
                                              "Completed"
                                          ? false
                                          : taskOwner == false &&
                                          widget.tasks.status !=
                                              "Completed"
                                          ? true:taskOwner == false &&
                                          widget.tasks.status ==
                                              "Completed"?false
                                          : true,
                                      child:
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
                                        ))),
                                    SizedBox(
                                      width: 10,
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
                                    Expanded(
                                        child: DefaultButton1(
                                          press: () {
                                             deleteTask();
                                          },
                                          text: "Delete",
                                          height: 48,
                                          background: textonecolor,
                                          textcolor: Colors.white,
                                        ))),
                                  ],
                                ),
                            SizedBox(height: 20,)
                          ]))
                  ],
                ))))));
  }
}
