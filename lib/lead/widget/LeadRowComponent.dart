import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/constant/const_color.dart';
import '../../utils/constant/constants.dart';

class LeadRowComponent extends StatelessWidget {
  final String title;
  final String tovalue;
  final String byvalue;

  final String status;
  final Function(int mainindex, int subindex) onpress;
  final int mainindex;
  final int subindex;
  final String taskstatus;
  final String loguserID;
  final String assignID;
  final String createdbyID;
   String leadstatus;
  final String specifier;
  final Function(int mainindex, int subindex,String leadstatus) onStatuschange;
  final String mobile;


  LeadRowComponent(
      {required this.title,
      required this.tovalue,
      required this.status,
      required this.onpress,
      required this.mainindex,
      required this.subindex,
      required this.taskstatus,
      required this.loguserID,
      required this.assignID,
      required this.createdbyID,
      required this.byvalue,
        required this.leadstatus,
        required this.specifier,
        required this.onStatuschange, required this.mobile,

      });

  var itemsTask = [
    'Open',
    'Deal',
    'Follow-Up',
    'Close'
  ];
  //String tasktype = 'Open';

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          onpress(mainindex, subindex);
        },
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(left: 0, right: 0, top: 4, bottom: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.circle,
                    size: 15,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                      child: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 16.0,
                        color: textcolor,
                        fontWeight: FontWeight.w500),
                  )),
                  Spacer(),
                  Icon(
                    Icons.flag,
                    size: 21,
                    color: status == 'High'
                        ? Colors.red
                        : status == 'Medium'
                            ? Colors.yellow
                            : Colors.green,
                  ),
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
                  Icon(
                    Icons.account_circle,
                    size: 15,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    loguserID == assignID && loguserID == createdbyID
                        ? 'Self'
                        : loguserID == createdbyID && loguserID != assignID
                            ? tovalue
                            : loguserID != createdbyID && loguserID == assignID
                                ? byvalue
                                : tovalue,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 14.0,
                        color: textcolor,
                        fontWeight: FontWeight.w400),
                  ),
                  Spacer(),
                  /*Visibility(
                      visible: repeattype == "Yes" ? true : false,
                      child: Icon(
                        Icons.repeat,
                        size: 21,
                      )),*/
                ],
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(
                    left: 0, right: 0, top: 5.0, bottom: 5.0),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [

                      Container(height: 50.0,
                          decoration: BoxDecoration(
                              color: specifier == "Specifier"?iconcolorspecifier:iconcolorcustomer,
                              borderRadius: BorderRadius.all(Radius.circular(8))
                          ),
                      child:  Center(
                        child:Padding(padding: EdgeInsets.only(left: 5.0,right: 5.0),child:Text(
                            specifier,
                          style: TextStyle(
                            fontSize: 14,
                            color: specifier == "Specifier"?Colors.lightBlue:Colors.red,
                            fontWeight: FontWeight.w400,
                          )),
                      ))),
                  SizedBox(width: 10.0,),
                  Expanded(
                      child: DropdownButtonFormField<String>(
                          itemHeight: 50.0,
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white,
                          ),
                          value: leadstatus,
                          hint: const Text("Assign To",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              )),
                          selectedItemBuilder: (BuildContext context) {
                            //<-- SEE HERE
                            return itemsTask.map((String value) {
                              return Text(
                                leadstatus,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 14),
                              );
                            }).toList();
                          },
                          items: itemsTask.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items,
                                  style: TextStyle(color: Colors.black)),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            leadstatus = newValue!;

                            onStatuschange(mainindex, subindex,leadstatus);

                          },
                          decoration: InputDecoration(
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                    color: leadstatus == "Deal"?Colors.green:leadstatus == "Follow-Up"?Colors.amber:Colors.redAccent,
                                    width: 1.0,
                                  )),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                    color: leadstatus == "Deal"?Colors.green:leadstatus == "Follow-Up"?Colors.amber:Colors.redAccent,
                                    width: 1.0,
                                  )),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                    color: leadstatus == "Deal"?Colors.green:leadstatus == "Follow-Up"?Colors.amber:Colors.redAccent,
                                    width: 1.0,
                                  )),
                              labelStyle: TextStyle(color: Colors.black),
                              filled: true,
                              focusColor: Colors.black,
                              fillColor: leadstatus == "Deal"?Colors.green:leadstatus == "Follow-Up"?Colors.amber:Colors.redAccent,
                              isDense: true))),
                      SizedBox(width: 10.0,),

                InkWell(onTap: () async {
                  await launch ("tel:${mobile}");

                },child:
                      Container(height: 50.0,
                          width: 50.0,
                          decoration: BoxDecoration(
                            color: Colors.lightBlue,
                              borderRadius: BorderRadius.all(Radius.circular(8))
                          ),
                          child: const Center(
                              child:Padding(padding: EdgeInsets.only(left: 5.0,right: 5.0),child:Icon(Icons.call,color: Colors.white,size:18.0)
                              )))),

                ])),
            Padding(
                padding: const EdgeInsets.only(
                    left: 0, right: 0, top: 5.0, bottom: 5.0),
                child: Divider(color: Colors.black12))
          ],
        ));
  }
}
