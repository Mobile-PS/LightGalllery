
import 'package:flutter/material.dart';

import '../../utils/constant/const_color.dart';

class CustomRowComponentProject extends StatelessWidget {

  final String title;
  final String tovalue;
  final String byvalue;

  final String status;
  final Function(int mainindex, int subindex) onpress;
  final int  mainindex;
  final int subindex;
  final String taskstatus;
  final String loguserID;
  final String assignID;
  final String repeattype;
  final String createdbyID;


  CustomRowComponentProject({required this.title, required this.tovalue, required this.status, required this.onpress, required this.mainindex, required this.subindex, required this.taskstatus, required this.loguserID, required this.assignID, required this.repeattype, required this.createdbyID, required this.byvalue});

  @override
  Widget build(BuildContext context) {
    return InkWell(onTap: () {
      onpress(mainindex,subindex);
    },child:Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(left: 0, right: 0, top: 4, bottom: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.circle,size: 15,),
          SizedBox(width: 5,),
              Expanded(child:
              Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 16.0, color: textcolor,fontWeight: FontWeight.w500),
              )),
             Spacer(),
             Icon(Icons.flag,size: 21,color: status =='High'?Colors.red:status =='Medium'?Colors.yellow:Colors.green,),
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
       /* Padding(
          padding:
          const EdgeInsets.only(left: 20, right: 0, top: 4, bottom: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.account_circle,size: 15,),
              SizedBox(width: 5,),

              Text(
                tovalue,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 14.0, color: textcolor,fontWeight: FontWeight.w400),
              ),

              Spacer(),
              Visibility(
                  visible: repeattype == "Yes"?true:false,
                  child:
              Icon(Icons.repeat,size: 21,)),


            ],
          ),
        ),*/

        Padding(
          padding: const EdgeInsets.only(left: 0, right: 0,top: 5.0,bottom: 5.0),
          child: Divider
          (color: Colors.black12)
        )
      ],
    ));
  }
}
