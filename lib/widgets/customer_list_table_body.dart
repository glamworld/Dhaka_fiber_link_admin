import 'package:flutter/material.dart';
import 'package:new_dish_admin_panlel/provider/customer_provider.dart';
import 'package:new_dish_admin_panlel/provider/public_provider.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class CustomerListTableBody extends StatefulWidget {
  int? id;
  String? name,address,phone,password,activity,package,installationFee,billAmount;

  CustomerListTableBody({this.id,this.name,this.address,this.phone,this.password,this.activity,this.package,this.installationFee,this.billAmount});

  @override
  _State createState() => _State();
}

class _State extends State<CustomerListTableBody> {
  bool _isLoading=false;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final PublicProvider publicProvider = Provider.of<PublicProvider>(context);
    final CustomerProvider customerProvider =
        Provider.of<CustomerProvider>(context);

    return _isLoading?Center(child: CircularProgressIndicator()):Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _tableBodyBuilder(
                  size,
                  '${widget.id!}',
                  publicProvider,customerProvider),
              _tableBodyBuilder(
                  size,
                  widget.name!,
                  publicProvider,customerProvider),
              _tableBodyBuilder(
                  size,
                  widget.phone!,
                  publicProvider,customerProvider),
              _tableBodyBuilder(
                  size,
                  widget.address!,
                  publicProvider,customerProvider),
              _tableBodyBuilder(
                  size,
                  widget.installationFee!,
                  publicProvider,customerProvider),
              _tableBodyBuilder(
                  size,
                  widget.package!,
                  publicProvider,customerProvider),
              _tableBodyBuilder(
                  size,
                  widget.billAmount!,
                  publicProvider,customerProvider),
              _tableBodyBuilder(
                  size,
                  widget.activity!,
                  publicProvider,customerProvider),
              _tableBodyBuilder(size, '', publicProvider,customerProvider),
            ],
          ),
          SizedBox(height: 5.0),
          Divider(height: 5.0, thickness: 0.5, color: Colors.grey)
        ],
      ),
    );
  }

  Widget _tableBodyBuilder(
      Size size, String tableData, PublicProvider publicProvider,CustomerProvider customerProvider) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        child: tableData.isNotEmpty
            ? Text('$tableData ',//${widget.index}',
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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
//         ElevatedButton(
//   style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Color(0xff006F64))),
//   child: Text('details',
//           style: TextStyle(fontSize: size.height*.015,fontFamily: 'OpenSans',color: Colors.white)),
//   onPressed: (){
//         // publicProvider.category= publicProvider.subCategory;
//         // publicProvider.subCategory='Pay Bill';
//   },
// ),
//         SizedBox(width: size.height*.01),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color(0xffF0A732))),
                    child: Text('update',
                        style: TextStyle(
                            fontSize: size.height * .015,
                            fontFamily: 'OpenSans',
                            color: Colors.white)),
                    onPressed: () {
                      publicProvider.category = publicProvider.subCategory;
                      publicProvider.subCategory = 'Update Customer';
                      setState(() {
                        publicProvider.customerModel.id=widget.id;
                        publicProvider.customerModel.name=widget.name;
                        publicProvider.customerModel.address=widget.address;
                        publicProvider.customerModel.activity=widget.activity;
                        publicProvider.customerModel.phone=widget.phone;
                        publicProvider.customerModel.billAmount=widget.billAmount;
                        publicProvider.customerModel.package=widget.package;
                        publicProvider.customerModel.password=widget.password;
                      });
                    },
                  ),
                  SizedBox(width: 5.0),
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          Widget okButton = FlatButton(
                            child: Text("YES"),
                            onPressed: () async{
                              Navigator.of(context).pop();
                              setState(() {
                                _isLoading=true;
                              });
                              await customerProvider.deleteCustomer(widget.id!).then((value){
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
                            title: Text("Are you sure you want to remove this Customer?"),
                            content: Text("This Customer will be removed"),
                            actions: [
                              noButton,
                              okButton
                            ],
                          );
                          return alert;
                        },
                      );
                    },
                    icon: Icon(Icons.delete, color: Colors.redAccent),
                    splashRadius: 25,
                  )
                ],
              ),
      ),
    );
  }
}
