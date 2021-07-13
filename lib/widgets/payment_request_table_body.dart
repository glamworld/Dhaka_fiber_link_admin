import 'package:flutter/material.dart';
import 'package:new_dish_admin_panlel/provider/billing_provider.dart';
import 'package:new_dish_admin_panlel/provider/customer_provider.dart';
import 'package:new_dish_admin_panlel/provider/head_provider.dart';
import 'package:new_dish_admin_panlel/provider/public_provider.dart';
import 'package:new_dish_admin_panlel/widgets/form_decoration.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable


class PaymentRequestTableBody extends StatefulWidget {
  String? id,userId,name,phone,paidBy,deductKey,billingNumber,transactionId,billingMonth,billingYear,payDate,billAmount;
PaymentRequestTableBody({this.id,this.userId,this.name,this.phone,this.paidBy,this.deductKey,this.billingNumber,this.transactionId,
  this.billingMonth,this.billingYear,this.payDate,this.billAmount});

  @override
  _PaymentRequestTableBodyState createState() => _PaymentRequestTableBodyState();
}

class _PaymentRequestTableBodyState extends State<PaymentRequestTableBody> {
  DateTime? currentMonth;
  DateTime? billMonth;
  var months;
  @override
  Widget build(BuildContext context) {
    String? billMonth;
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
    final Size size = MediaQuery.of(context).size;
    final PublicProvider publicProvider  = Provider.of<PublicProvider>(context);
    final CustomerProvider customerProvider = Provider.of<CustomerProvider>(context);
    final BillingProvider billingProvider = Provider.of<BillingProvider>(context);
    final HeadProvider headProvider = Provider.of<HeadProvider>(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _tableBodyBuilder(size, widget.userId!, publicProvider,billingProvider,customerProvider,headProvider),
              _tableBodyBuilder(size, widget.name!, publicProvider,billingProvider,customerProvider,headProvider),
              _tableBodyBuilder(size, widget.phone!, publicProvider,billingProvider,customerProvider,headProvider),
              _tableBodyBuilder(size, widget.paidBy!, publicProvider,billingProvider,customerProvider,headProvider),
              _tableBodyBuilder(size, widget.deductKey!, publicProvider,billingProvider,customerProvider,headProvider),
              _tableBodyBuilder(size, widget.billingNumber!,publicProvider,billingProvider,customerProvider,headProvider),
              _tableBodyBuilder(size, widget.transactionId!,publicProvider,billingProvider,customerProvider,headProvider),
              _tableBodyBuilder(size, '$billMonth-${widget.billingYear}',publicProvider,billingProvider,customerProvider,headProvider),
              _tableBodyBuilder(size, widget.payDate!,publicProvider,billingProvider,customerProvider,headProvider),
              _tableBodyBuilder(size, widget.billAmount!,publicProvider,billingProvider,customerProvider,headProvider),
              _tableBodyBuilder(size, '',publicProvider,billingProvider,customerProvider,headProvider),
            ],
          ),
          SizedBox(height: 5.0),
          Divider(height: 5.0,thickness: 0.5,color: Colors.grey)
        ],
      ),
    );
  }

  Widget _tableBodyBuilder(Size size,String tableData,PublicProvider publicProvider,BillingProvider billingProvider,
      CustomerProvider customerProvider,HeadProvider headProvider){
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(),
        child: tableData.isNotEmpty? Text(
            tableData,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.grey.shade900,
                fontSize: size.height*.021,
                fontWeight: FontWeight.w400,
                fontFamily: 'OpenSans'
            ))
            :ElevatedButton(
          style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Color(0xff006F64))),
          child: Text('Approve',
              style: TextStyle(fontSize: size.height*.018,fontFamily: 'OpenSans',color: Colors.white)),
          onPressed: (){
            _checkValidity(billingProvider,publicProvider,customerProvider,headProvider);
          },
        ),
      ),
    );
  }
  Future<void> _checkValidity(BillingProvider auth,PublicProvider publicProvider,CustomerProvider customerProvider,HeadProvider headProvider) async {
    //publicProvider.customerModel.dueAmount=null;
    setState(() {
      currentMonth = DateTime.utc(DateTime.now().year, DateTime.now().month);

      billMonth = DateTime.utc(int.parse(widget.billingYear!), int.parse(widget.billingMonth!));
    });
    var years = currentMonth!.difference(billMonth!);
    months = years.inDays ~/ 30;
    int due=int.parse(widget.billAmount!);
    num dueNum=due*months;
    String dueAmount='$dueNum';
      setState(() {
        auth.billingInfoModel.name=widget.name;
        auth.billingInfoModel.amount=widget.billAmount;
        auth.billingInfoModel.deductKey=widget.deductKey;
        auth.billingInfoModel.billingMonth = '${widget.billingMonth}';
        auth.billingInfoModel.billingYear = '${widget.billingYear}';
        publicProvider.customerModel.lastEntryMonth='${widget.billingMonth}';
        publicProvider.customerModel.lastEntryYear='${widget.billingYear}';
        publicProvider.customerModel.dueAmount=dueAmount;
        dueAmount=='0'?publicProvider.customerModel.billState='paid':publicProvider.customerModel.billState='due';
      });
      showToast('Approving..');
     auth.approveUserBill(widget.id!,auth.billingInfoModel,headProvider,customerProvider).
     then((value){
          customerProvider.updateCustomerState(int.parse(widget.userId!), publicProvider);
        });
  }
}

