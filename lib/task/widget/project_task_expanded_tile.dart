


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:expandable/expandable.dart';
import 'package:intl/intl.dart';

import '../../model/ProjectTaskListModel.dart';
import '../../utils/constant/const_color.dart';
import 'CustomRowComponent.dart';
import 'CustomRowComponentProject.dart';



class ProjectTaskExpandedTile extends StatelessWidget {
  ProjectTaskExpandedTile({Key? key, required this.quotesResults, required this.date, required this.Index, required this.onpress1, required this.userid})
      : super(key: key);

  final   ProjectData quotesResults;
  final String date;
  final int Index;
  final int userid;
  final Function(int mainindex,int subindex) onpress1;


  @override
  Widget build(BuildContext context) {
    List<Widget> _statusChild = [];

   /* quotesResults.forEach((element) {

      _statusChild.add(CustomRowComponent(title: element.title.toString(),value: element.assignedTo.toString(),status: element.priority.toString(),));
    });*/

   // for(int i= 0; i< quotesResults.length; i++){
      _statusChild.add(CustomRowComponentProject(title: quotesResults.title.toString(),byvalue: '0',tovalue: quotesResults.createdBy.toString(),status: quotesResults.priority.toString(),mainindex: Index,subindex: 0,taskstatus: quotesResults.status.toString(),createdbyID: quotesResults.createdBy.toString(),loguserID: userid.toString(),assignID:'0',repeattype:'' , onpress: (int mainindex,int subindex){
        onpress1(mainindex,subindex);
      },));

   // }

    String getDate(String date){

      // 2022-05-27T00:00:00
      DateTime parseDate = DateFormat("yyyy-MM-dd").parse(date);

      final DateFormat formatter = DateFormat('MMM dd yyyy');
      final String formatted = formatter.format(parseDate);

      return formatted;
    }



    buildCollapsed2() {
      return Container(
          margin: EdgeInsets.only(left: 20.0,right: 20.0,top: 10),
          child:
        Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [


          SizedBox(height: 10,),
         /* Row(children: [
            Text(
              getDate(date),
              style: TextStyle(fontSize: 16.0, color: headercolor,fontWeight: FontWeight.w600),
            ),
            SizedBox(width: 10,),

          ]),


          SizedBox(height: 5,),*/
          Column(children: _statusChild,),

        //  CustomRowComponent(title: 'Date',value: quotesResults.title.toString()!),
        /*  SizedBox(height: 5,),
          CustomRowComponent(title: 'Assign By',value: quotesResults.assignBy.toString()!),
          SizedBox(height: 5,),
          CustomRowComponent(title: 'Assign To',value: quotesResults.name.toString()!),*/

          SizedBox(height: 5,),
      ],));

    }

    buildExpanded2() {
      return Container(
          margin: EdgeInsets.only(left: 20.0,right: 20.0,top: 10),
          child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(height: 10,),
              /*Row(children: [
                Text(
                  getDate(date) ,
                  style: TextStyle(fontSize: 16.0, color: headercolor,fontWeight: FontWeight.w600),
                ),
              ]),
              SizedBox(height: 5,),*/
              Column(children: _statusChild,),
              SizedBox(height: 5,),

            ],));

    }


    return ExpandableNotifier(
        child: Padding(
      padding: const EdgeInsets.only(left: 0, right: 0, bottom: 2,top: 2),
      child: ScrollOnExpand(
        child: Card(
          clipBehavior: Clip.antiAlias,
          elevation: 1.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              Expandable(
                collapsed: buildCollapsed2(),
                expanded: buildExpanded2(),
              ),

             /* Padding(padding: EdgeInsets.only(left: 20.0,right: 20.0,top: 15.0,bottom: 10),
              child:
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Builder(
                    builder: (context) {
                      var controller =
                          ExpandableController.of(context, required: true);
                      return
                        GestureDetector(onTap: () {
                          controller?.toggle();

                        },child:
                        Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          controller!.expanded ?
                          Text(
                            'View Lesser Details',
                            style: TextStyle(fontSize: 12.0, color: Colors.black,fontFamily:'CastelTBook'),
                          ):Text(
                            'View More Details',
                            style: TextStyle(fontSize: 12.0, color: Colors.black,fontFamily:'CastelTBook'),
                          ),

                      ],));


                       *//* TextButton(
                        child: Text(
                          controller.expanded ? "COLLAPSE" : "EXPAND",
                          style: Theme.of(context)
                              .textTheme
                              .button
                              .copyWith(color: Colors.deepPurple),
                        ),
                        onPressed: () {
                          controller.toggle();
                        },
                      );*//*
                    },
                  ),
                ],
              )),*/
            ],
          ),
        ),
      ),
    ));
  }
}
