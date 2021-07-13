import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_dish_admin_panlel/provider/customer_provider.dart';
import 'package:new_dish_admin_panlel/provider/public_provider.dart';
import 'package:provider/provider.dart';

class PaidCustomerListTableBody extends StatefulWidget {
  String? id,name,address,phone,package,billAmount,activity;

  PaidCustomerListTableBody({this.id,this.name,this.address,this.phone,
    this.package,this.billAmount,this.activity});
  @override
  _PaidCustomerListTableBodyState createState() => _PaidCustomerListTableBodyState();
}

class _PaidCustomerListTableBodyState extends State<PaidCustomerListTableBody> {
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
              _tableBodyBuilder(
                  size,
                  widget.id!,
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
            :Container()
      ),
    );
  }
}
