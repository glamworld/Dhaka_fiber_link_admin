import 'package:flutter/material.dart';
import 'package:new_dish_admin_panlel/model/billing_info_model.dart';
import 'package:new_dish_admin_panlel/provider/billing_provider.dart';
import 'package:new_dish_admin_panlel/provider/public_provider.dart';
import 'package:new_dish_admin_panlel/widgets/form_decoration.dart';
import 'package:new_dish_admin_panlel/widgets/payment_request_table_body.dart';
import 'package:provider/provider.dart';

class PaymentRequestList extends StatefulWidget {

  @override
  _PaymentRequestListState createState() => _PaymentRequestListState();
}

class _PaymentRequestListState extends State<PaymentRequestList> {
  bool _isLoading=false;
  var _controller = TextEditingController();
  List<BillingInfoModel> filteredBills = [];
  List<BillingInfoModel> billList = [];
  int _counter = 0;
  String? searchString;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final PublicProvider publicProvider = Provider.of<PublicProvider>(context);
    final BillingProvider billingProvider = Provider.of<BillingProvider>(context);
    if (_counter == 0) {
      setState(() {
        billList=billingProvider.pendingBillList;
        filteredBills=billList;
        _counter++;
      });
    }

    return Container(
      width: publicProvider.pageWidth(size),
      child: Column(
        children: [
          ///Search Header
          Container(
            height: 50,
            margin: EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: publicProvider.pageWidth(size),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: TextFormField(
                            controller: _controller,
                            decoration: formDecoration(size).copyWith(
                              labelText: 'Search by Transaction ID',
                            ),
                            onChanged: (string){
                              setState(() {
                                searchString=string;
                              });
                            },
                          ),
                        ),
                      ),

                      ///Search Button
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: size.height * .008),
                        child: OutlinedButton(
                          onPressed: (){
                            setState(() {
                              filteredBills = billList
                                  .where((u) => (u.transactionId!
                                  .contains(searchString!.toLowerCase())))
                                  .toList();
                            });
                          },
                          child: Padding(
                              padding: EdgeInsets.symmetric(vertical: size.height*.011),
                              child: Icon(Icons.search,color: Colors.grey)),
                        ),
                      ),

                      ///Clear Button
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: size.height * .008),
                        child: OutlinedButton(
                          onPressed: (){
                            _controller.clear();
                          },
                          child: Padding(
                              padding: EdgeInsets.symmetric(vertical: size.height*.011),
                              child: Icon(Icons.clear,color: Colors.redAccent)),
                        ),
                      ),

                      ///Reload Button
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: size.height * .008),
                        child: OutlinedButton(
                          onPressed: (){
                            setState(() {
                              billList=billingProvider.pendingBillList;
                              filteredBills=billList;
                            });
                          },
                          child: Padding(
                              padding: EdgeInsets.symmetric(vertical: size.height*.011),
                              child: Icon(Icons.refresh,color: Color(0xff006F64),)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(),

          ///Table Header
          Container(
            height: 40,
            margin: EdgeInsets.only(top: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _tableHeaderBuilder(size, 'Id'),
                    _tableHeaderBuilder(size, 'Name'),
                    _tableHeaderBuilder(size, 'Phone'),
                    _tableHeaderBuilder(size, 'Paid By'),
                    _tableHeaderBuilder(size, 'Deduct Key'),
                    _tableHeaderBuilder(size, 'Billing Number'),
                    _tableHeaderBuilder(size, 'Transaction ID'),
                    _tableHeaderBuilder(size, 'Billing Month'),
                    _tableHeaderBuilder(size, 'Payment date'),
                    _tableHeaderBuilder(size, 'Amount'),
                    _tableHeaderBuilder(size, ''),
                  ],
                ),
                Divider(height: 5.0,color: Colors.grey.shade900)
              ],
            ),
          ),

          ///Table Body
          _isLoading
              ?Padding(
            padding:  EdgeInsets.only(top: 100),
            child: Center(child: spinCircle()),
          ): Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: filteredBills.length,
              itemBuilder: (context,index)=>PaymentRequestTableBody(
                id: filteredBills[index].id,
                userId: filteredBills[index].userID,
                name: filteredBills[index].name,
                phone: filteredBills[index].userPhone,
                paidBy: filteredBills[index].payBy,
                deductKey: filteredBills[index].deductKey,
                billingNumber: filteredBills[index].billingNumber,
                transactionId: filteredBills[index].transactionId,
                billingMonth: filteredBills[index].billingMonth,
                billingYear: filteredBills[index].billingYear,
                payDate: filteredBills[index].payDate,
                billAmount: filteredBills[index].amount,
              ),
            ),
          )
          //     :Center(child: Column(
          //   children: [
          //     SizedBox(height: 100),
          //     Text('কোন ডেটা নেই!',
          //         style: TextStyle(fontFamily: 'hindSiliguri',
          //             fontSize: size.height*.026,color: Color(0xffF5B454))),
          //     TextButton(
          //         onPressed: ()async{
          //           setState(()=>_isLoading=true);
          //           await databaseProvider.getBodliKhanaDataList().then((value){
          //             setState(()=>_isLoading=false);
          //           });
          //         },
          //         child: Text('রিফ্রেশ করুন',style: TextStyle(fontFamily: 'hindSiliguri',fontSize: size.height*.021,),)
          //     )
          //   ],
          // ))
        ],
      ),
    );
  }

  Widget _tableHeaderBuilder(Size size,String tableHeader){
    return Expanded(
      child: Container(
        // width: size.width<1300
        //     ?size.width*.111
        //     :size.width*.0888,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          // border: Border.all(color: Colors.grey.shade900)
        ),
        child: Text(
          tableHeader,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.grey.shade900,
              fontSize: size.height*.022,
              fontWeight: FontWeight.bold,
              fontFamily: 'hindSiliguri'
          ),),
      ),
    );
  }
}
