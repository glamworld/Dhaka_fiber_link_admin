import 'package:flutter/material.dart';
import 'package:new_dish_admin_panlel/provider/public_provider.dart';
import 'package:provider/provider.dart';

class BillingInfoTableBody extends StatefulWidget {
  String? userId,name,phone,billingNumber,transactionId,billingMonth,billingYear,payBy,deductKey,payDate,amount;
  BillingInfoTableBody({this.userId,this.name,this.phone,this.billingNumber,this.transactionId,
  this.billingMonth,this.billingYear,this.payBy,this.deductKey,this.payDate,this.amount});
  @override
  _BillingInfoTableBodyState createState() => _BillingInfoTableBodyState();
}

class _BillingInfoTableBodyState extends State<BillingInfoTableBody> {
  @override
  Widget build(BuildContext context) {
    String? billMonth;
    final Size size = MediaQuery.of(context).size;
    final PublicProvider publicProvider  = Provider.of<PublicProvider>(context);
    setState(() {
      widget.billingMonth=='1'?billMonth='Jan':
      widget.billingMonth=='2'?billMonth='Feb':
      widget.billingMonth=='3'?billMonth='Mar':
      widget.billingMonth=='4'?billMonth='Apr':
      widget.billingMonth=='5'?billMonth='May':
      widget.billingMonth=='6'?billMonth='Jun':
      widget.billingMonth=='7'?billMonth='Jul':
      widget.billingMonth=='8'?billMonth='Aug':
      widget.billingMonth=='9'?billMonth='Sept':
      widget.billingMonth=='10'?billMonth='Oct':
      widget.billingMonth=='11'?billMonth='Nov':
      billMonth='Dec';
    });
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _tableBodyBuilder(size, widget.userId!, publicProvider),
              _tableBodyBuilder(size, widget.name!, publicProvider),
              _tableBodyBuilder(size, widget.phone!, publicProvider),
              _tableBodyBuilder(size, widget.billingNumber!,publicProvider),
              _tableBodyBuilder(size, widget.transactionId!,publicProvider),
              _tableBodyBuilder(size, '$billMonth-${widget.billingYear!}',publicProvider),
              _tableBodyBuilder(size, widget.payBy!,publicProvider),
              _tableBodyBuilder(size, widget.deductKey!,publicProvider),
              _tableBodyBuilder(size, widget.payDate!,publicProvider),
              _tableBodyBuilder(size, widget.amount!,publicProvider),
            ],
          ),
          SizedBox(height: 5.0),
          Divider(height: 5.0,thickness: 0.5,color: Colors.grey)
        ],
      ),
    );
  }

  Widget _tableBodyBuilder(Size size,String tableData,PublicProvider publicProvider){
    return Expanded(
      child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(),
          child:Text(
              tableData,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.grey.shade900,
                  fontSize: size.height*.021,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'OpenSans'
              ))

      ),
    );
  }
}

