import 'dart:js';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_dish_admin_panlel/provider/customer_provider.dart';
import 'package:new_dish_admin_panlel/provider/public_provider.dart';
import 'package:new_dish_admin_panlel/widgets/form_decoration.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class CustomerProblemTableBody extends StatelessWidget {
  String? name,address,phone,problem,issueDate,status;

  CustomerProblemTableBody({this.name,this.address,this.phone,this.problem,this.issueDate,this.status});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final PublicProvider publicProvider = Provider.of<PublicProvider>(context);
    final CustomerProvider customerProvider = Provider.of<CustomerProvider>(context);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _tableBodyBuilder(size, problem!, publicProvider,customerProvider,context,phone!),
              _tableBodyBuilder(size, phone!, publicProvider,customerProvider,context,phone!),
              _tableBodyBuilder(size, name!, publicProvider,customerProvider,context,phone!),
              _tableBodyBuilder(size, address!, publicProvider,customerProvider,context,phone!),
              _tableBodyBuilder(size, issueDate!, publicProvider,customerProvider,context,phone!),
              _tableBodyBuilder(size, status!, publicProvider,customerProvider,context,phone!),
            ],
          ),
          SizedBox(height: 5.0),
          Divider(height: 5.0, thickness: 0.5, color: Colors.grey)
        ],
      ),
    );
  }

  Widget _tableBodyBuilder(
      Size size, String tableData, PublicProvider publicProvider,CustomerProvider customerProvider,BuildContext context,String id) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(),
        child:tableData == 'pending'
            ?  Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('$tableData',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color:tableData == 'pending'?Color(0xffF0A732): Color(0xff006F64),
                          fontSize: size.height * .021,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.italic,
                          fontFamily: 'OpenSans')),
                  SizedBox(width: 25),
                  tableData == 'pending'
                      ? ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Color(0xff006F64))),
                    child: Text('Fix',
                        style: TextStyle(
                            fontSize: size.height * .018,
                            fontFamily: 'OpenSans',
                            color: Colors.white)),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          Widget okButton = FlatButton(
                            child: Text("YES"),
                            onPressed: () async{
                              Navigator.of(context).pop();
                              await FirebaseFirestore.instance.collection('UserProblems').doc(id).update({
                                'status': 'fixed'
                              }).then((value){
                                customerProvider.getUserProblem();
                                showToast('Problem Fixed');
                              });

                            },
                          );
                          Widget noButton = FlatButton(
                            child: Text("No"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          );
                          AlertDialog alert = AlertDialog(
                            title: Text("Did you Solved this problem?"),
                            actions: [
                              noButton,
                              okButton
                            ],
                          );
                          return alert;
                        },
                      );


                    },
                  ):Container(),
                  SizedBox(width: 10),
                ],
              )
            :Text('$tableData',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: tableData == 'Pending'
                    ? Color(0xffF0A732)
                    : tableData == 'solved'
                    ?Color(0xff006F64)
                    :Colors.grey.shade900,
                fontSize: size.height * .021,
                fontWeight: FontWeight.w400,
                fontStyle:tableData == 'Pending' || tableData == 'solved'? FontStyle.italic:FontStyle.normal,
                fontFamily: 'OpenSans')),
      ),
    );
  }
}
