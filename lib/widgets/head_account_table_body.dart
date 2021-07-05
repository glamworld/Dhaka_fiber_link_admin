import 'package:flutter/material.dart';
import 'package:new_dish_admin_panlel/provider/head_provider.dart';
import 'package:new_dish_admin_panlel/provider/public_provider.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable

class HeadOfAccountTableBody extends StatefulWidget {
  String? id, title, name, details, debit, credit,month,year;

  HeadOfAccountTableBody(
      {this.id, this.title, this.name, this.details, this.debit, this.credit,this.month,this.year});

  @override
  _HeadOfAccountTableBodyState createState() => _HeadOfAccountTableBodyState();
}

class _HeadOfAccountTableBodyState extends State<HeadOfAccountTableBody> {
 bool _isLoading=false;
  @override
  Widget build(BuildContext context) {
    String? billMonth;
    final Size size = MediaQuery.of(context).size;
    final PublicProvider publicProvider = Provider.of<PublicProvider>(context);
    final HeadProvider headProvider = Provider.of<HeadProvider>(context);
    setState(() {
      widget.month=='1'?billMonth='Jan':
      widget.month=='2'?billMonth='Feb':
      widget.month=='3'?billMonth='Mar':
      widget.month=='4'?billMonth='Apr':
      widget.month=='5'?billMonth='May':
      widget.month=='6'?billMonth='Jun':
      widget.month=='7'?billMonth='Jul':
      widget.month=='8'?billMonth='Aug':
      widget.month=='9'?billMonth='Sept':
      widget.month=='10'?billMonth='Oct':
      widget.month=='11'?billMonth='Nov':
      billMonth='Dec';
    });
    return _isLoading?Center(child: CircularProgressIndicator()):Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _tableBodyBuilder(
                  size, '$billMonth-${widget.year!}', publicProvider, context, headProvider),
              _tableBodyBuilder(
                  size, widget.title!, publicProvider, context, headProvider),
              _tableBodyBuilder(
                  size, widget.name!, publicProvider, context, headProvider),
              _tableBodyBuilder(
                  size, widget.details!, publicProvider, context, headProvider),
              _tableBodyBuilder(
                  size, widget.debit!, publicProvider, context, headProvider),
              _tableBodyBuilder(
                  size, widget.credit!, publicProvider, context, headProvider),
              _tableBodyBuilder(
                  size, '', publicProvider, context, headProvider),
            ],
          ),
          SizedBox(height: 5.0),
          Divider(height: 5.0, thickness: 0.5, color: Colors.grey)
        ],
      ),
    );
  }

  Widget _tableBodyBuilder(
      Size size,
      String tableData,
      PublicProvider publicProvider,
      BuildContext context,
      HeadProvider headProvider) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        child: tableData.isNotEmpty
            ? Text('$tableData', // $index',
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
                      publicProvider.subCategory = 'Update Head';
                      setState(() {
                       publicProvider.headModel.id=widget.id;
                       publicProvider.headModel.name=widget.name;
                       publicProvider.headModel.title=widget.title;
                       publicProvider.headModel.debit=widget.debit;
                       publicProvider.headModel.details=widget.details;
                       publicProvider.headModel.credit=widget.credit;
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
                            onPressed: () async {
                              Navigator.of(context).pop();
                              setState(() {
                               _isLoading=true;
                              });
                              await headProvider.deleteHead(widget.id!).then((value){
                               setState(() {
                                _isLoading=false;
                               });
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
                            title: Text(
                                "Are you sure you want to delete this record?"),
                            content: Text("This record will be deleted"),
                            actions: [noButton, okButton],
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
