import 'package:flutter/material.dart';
import 'package:new_dish_admin_panlel/provider/bill_man_provider.dart';
import 'package:new_dish_admin_panlel/provider/public_provider.dart';
import 'package:provider/provider.dart';
// ignore: must_be_immutable

class BillManTableBody extends StatefulWidget {
 String? id,name,phone,password,address;

  BillManTableBody({this.id,this.name,this.phone,this.address,this.password});

  @override
  _State createState() => _State();
}

class _State extends State<BillManTableBody> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final PublicProvider publicProvider = Provider.of<PublicProvider>(context);
    final BillManProvider billManProvider =
        Provider.of<BillManProvider>(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _tableBodyBuilder(size, widget.name!, publicProvider,billManProvider),
              _tableBodyBuilder(size, widget.phone!, publicProvider,billManProvider),
              _tableBodyBuilder(size, widget.password!, publicProvider,billManProvider),
              _tableBodyBuilder(size, widget.address!, publicProvider,billManProvider),
              _tableBodyBuilder(size, '', publicProvider,billManProvider),
            ],
          ),
          SizedBox(height: 5.0),
          Divider(height: 5.0, thickness: 0.5, color: Colors.grey)
        ],
      ),
    );
  }

  Widget _tableBodyBuilder(
      Size size, String tableData, PublicProvider publicProvider,BillManProvider billManProvider) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        child: tableData.isNotEmpty
            ? Text('$tableData',// ${widget.index}',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: tableData == 'Active'
                        ? Color(0xff006F64)
                        : tableData == 'Inactive'
                            ? Colors.deepOrange
                            : Colors.grey.shade900,
                    fontSize: size.height * .021,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'OpenSans'))
            : Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color(0xff006F64))),
                    child: Text('Update',
                        style: TextStyle(
                            fontSize: size.height * .015,
                            fontFamily: 'OpenSans',
                            color: Colors.white)),
                    onPressed: () {
                      publicProvider.category = publicProvider.subCategory;
                      publicProvider.subCategory = 'Update Bill Man';
                      setState(() {
                        publicProvider.billManModel.id = widget.id;
                        publicProvider.billManModel.name = widget.name;
                        publicProvider.billManModel.address = widget.address;
                        publicProvider.billManModel.phone = widget.phone;
                        publicProvider.billManModel.password = widget.password;
                      });
                    },
                  ),
                  SizedBox(width: size.height * .03),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color(0xffF0A732))),
                    child: Text('Delete',
                        style: TextStyle(
                            fontSize: size.height * .015,
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
                              await billManProvider.deleteBillMan(widget.id!);
                            },
                          );
                          Widget noButton = FlatButton(
                            child: Text("No"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          );
                          AlertDialog alert = AlertDialog(
                            title: Text("Are you sure you want to remove this BillMan?"),
                            content: Text("This BillMan will be removed"),
                            actions: [
                              noButton,
                              okButton
                            ],
                          );
                          return alert;
                        },
                      );
                    },
                  ),
                  SizedBox(width: size.height * .02),
                ],
              ),
      ),
    );
  }
}
