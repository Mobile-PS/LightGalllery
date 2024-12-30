
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

import '../dashboard/dashboard_screen.dart';
import '../lead/lead_list.dart';
import '../profile/profile_screen.dart';
import '../project/project_list.dart';
import '../splash_screen/comming_soon.dart';
import '../task/task_list.dart';
import '../utils/common_widget/default_button.dart';
import '../utils/constant/const_color.dart';
import '../utils/constant/constants.dart';

class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  // final siginInController = Get.put(SigninPageController());
  // late WidgetsCollection _widgets;
  int _currentIndex = 0;

  Widget appBarTitle = Text(
    "Light's Gallery",
    style: TextStyle(color: Colors.white,fontSize: 18,
        fontWeight: FontWeight.w700),
  );


  final List<Widget> _children = [
    Dashboardscreen(),
    TaskListscreen(),
    ProjectListscreen(),
    LeadListscreen(),
    Profilescreen(),

  ];

  void onTap(int index) {

    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 1,
          centerTitle: false,
          title: appBarTitle,
          leading: Image.asset(
            constImage.appIcon,
            width: 24,
            height: 24,
          ),
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: primaryColor,
         /* actions: <Widget>[
            Padding(padding: EdgeInsets.only(right: 15.0),
                child:
                InkWell(onTap: () {
                 // createDialog(context);
                },child:
                Icon(
                  Icons.notifications,
                  color: Colors.white,
                  size: 30,
                ))),
          ]*/),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: white,
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        onTap: onTap,
        unselectedLabelStyle: TextStyle(
            fontSize: 12,
            color: headercolor,
            fontWeight: FontWeight.w400),
        selectedLabelStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400),
        items:  <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage(constImage.dashboardIcon)),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage(constImage.taskIcon)),
            label: 'Task',
          ),

          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage(constImage.projectIcon)),
            label: 'Project',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage(constImage.leadIcon)),
            label: 'Leads',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage(constImage.settingIcon)),
            label: 'Setting',
          ),
        ],
      ),
      body: SafeArea(
          child: Stack(
    children: <Widget>[
      _children[_currentIndex]
    ])),
    );
  }
}
