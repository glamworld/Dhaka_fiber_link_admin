import 'package:flutter/material.dart';
import 'package:new_dish_admin_panlel/model/billing_info_model.dart';
import 'package:new_dish_admin_panlel/provider/billing_provider.dart';
import 'package:new_dish_admin_panlel/provider/public_provider.dart';
import 'package:new_dish_admin_panlel/widgets/billing_info_table_body.dart';
import 'package:new_dish_admin_panlel/widgets/form_decoration.dart';
import 'package:provider/provider.dart';

class BillingInfoPage extends StatefulWidget {

  @override
  _BillingInfoPageState createState() => _BillingInfoPageState();
}

class _BillingInfoPageState extends State<BillingInfoPage> with SingleTickerProviderStateMixin{
  TabController? _tabController;
  bool _isLoading = false;
  DateTime? _date;
  var _controller = TextEditingController();
  List<BillingInfoModel> filteredBilling = [];
  List<BillingInfoModel> billingList = [];
  int _counter = 0;
  String? searchString;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initializeData();
  }

  _initializeData(){
    setState(() {
      _date = DateTime.now();
    });
  }

  Future<void> _pickDate(BuildContext context)async{
    final DateTime picked = (await showDatePicker(
        context: context,
        initialDate: _date!,
        firstDate:  DateTime(2010),
        lastDate: DateTime(2050)))!;
    if (picked != _date)
      setState(() {
        _date = picked;
      });
  }


  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final PublicProvider publicProvider = Provider.of<PublicProvider>(context);
    final BillingProvider billingProvider = Provider.of<BillingProvider>(context);
    if (_counter == 0) {
      setState(() {
        billingList=billingProvider.approvedBillList;
        filteredBilling=billingList;
        _counter++;
      });
    }

    return Container(
      width: publicProvider.pageWidth(size),
      child: Column(
        children: [
          Material(
            color: Color(0xff006F64),
            child: TabBar(
                controller: _tabController,
                indicatorColor: Colors.lightGreenAccent,
                indicatorWeight: 5.0,
                tabs: [
                  Tab(child: Text(
                      'All',
                      style: TextStyle(fontSize: size.height*.02,
                          color: Colors.white,
                          fontFamily: 'OpenSans'))
                  ),
                  Tab(child: Text(
                      'By Month',
                      style: TextStyle(fontSize: size.height*.02,color: Colors.white,
                          fontFamily: 'OpenSans'))
                  )
                ]
            ),
          ),
          Expanded(
            child: TabBarView(
                controller: _tabController,
                children: [
                  _all(size, publicProvider,billingProvider),
                  _byMonth(size, publicProvider,billingProvider),
                ]
            ),
          ),
        ],
      ),
    );
  }

  Widget _all(Size size, PublicProvider publicProvider,BillingProvider billingProvider)=>Container(
    child: Center(
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
                              labelText: 'Search by Customer Name',
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
                              filteredBilling = billingList
                                  .where((u) => (u.name!.toLowerCase()
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
                              billingList=billingProvider.approvedBillList;
                              filteredBilling=billingList;
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
                    _tableHeaderBuilder(size, 'User Id'),
                    _tableHeaderBuilder(size, 'Name'),
                    _tableHeaderBuilder(size, 'Phone'),
                    _tableHeaderBuilder(size, 'Billing Number'),
                    _tableHeaderBuilder(size, 'Transaction ID'),
                    _tableHeaderBuilder(size, 'Billing Month'),
                    _tableHeaderBuilder(size, 'Pay By'),
                    _tableHeaderBuilder(size, 'Deduct Key'),
                    _tableHeaderBuilder(size, 'Payment date'),
                    _tableHeaderBuilder(size, 'Amount'),
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
              itemCount: filteredBilling.length,
              itemBuilder: (context,index)=>BillingInfoTableBody(
                userId: filteredBilling[index].userID,
                name: filteredBilling[index].name,
                phone: filteredBilling[index].userPhone,
                billingNumber: filteredBilling[index].billingNumber,
                transactionId: filteredBilling[index].transactionId,
                billingMonth: filteredBilling[index].billingMonth,
                billingYear: filteredBilling[index].billingYear,
                payBy: filteredBilling[index].payBy,
                deductKey: filteredBilling[index].deductKey,
                payDate: filteredBilling[index].payDate,
                amount: filteredBilling[index].amount,
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
    ),
  );

  Widget _byMonth(Size size, PublicProvider publicProvider,BillingProvider billingProvider)=>Container(
    child: Center(
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

                      ///Calender Button
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: size.height * .008),
                        child: OutlinedButton(
                          onPressed: ()=>_pickDate(context),
                          child: Padding(
                              padding: EdgeInsets.symmetric(vertical: size.height*.011),
                              child: Icon(Icons.calendar_today_outlined,color: Color(0xff006F64))),
                        ),
                      ),

                      ///Text Field
                      Expanded(
                        child: InkWell(
                          onTap: ()=>_pickDate(context),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: size.height * .01,
                                vertical: size.height*.011),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.all(Radius.circular(5))
                            ),
                            child: Text('All Billing Record of:-  ${_date!.day}/${_date!.month}/${_date!.year}',
                                style: TextStyle(fontSize: size.height*.02,
                                    color: Colors.grey.shade900,
                                    fontFamily: 'OpenSans')),
                          ),
                            borderRadius: BorderRadius.all(Radius.circular(5))
                        ),
                      ),

                      ///Search Button
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: size.height * .008),
                        child: OutlinedButton(
                          onPressed: (){
                            setState(() {
                              filteredBilling = billingList
                                  .where((u) => ('${u.billingMonth}/${u.billingYear}'.toLowerCase()
                                  .contains('${_date!.month}/${_date!.year}'.toLowerCase())))
                                  .toList();
                            });
                          },
                          child: Padding(
                              padding: EdgeInsets.symmetric(vertical: size.height*.011),
                              child: Icon(Icons.search,color: Colors.grey)),
                        ),
                      ),
                      ///Clear Button
                    //   Padding(
                    //     padding: EdgeInsets.symmetric(horizontal: size.height * .008),
                    //     child: OutlinedButton(
                    //       onPressed: (){
                    //
                    //       },
                    //       child: Padding(
                    //           padding: EdgeInsets.symmetric(vertical: size.height*.011),
                    //           child: Icon(Icons.clear,color: Colors.redAccent)),
                    //     ),
                    //   ),
                      ///Reload Button
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: size.height * .008),
                        child: OutlinedButton(
                          onPressed: (){
                            setState(() {
                              billingList=billingProvider.approvedBillList;
                              filteredBilling=billingList;
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
                    _tableHeaderBuilder(size, 'User Id'),
                    _tableHeaderBuilder(size, 'Name'),
                    _tableHeaderBuilder(size, 'Phone'),
                    _tableHeaderBuilder(size, 'Billing Number'),
                    _tableHeaderBuilder(size, 'Transaction ID'),
                    _tableHeaderBuilder(size, 'Billing Month'),
                    _tableHeaderBuilder(size, 'Pay By'),
                    _tableHeaderBuilder(size, 'Deduct Key'),
                    _tableHeaderBuilder(size, 'Payment date'),
                    _tableHeaderBuilder(size, 'Amount'),
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
              itemCount: filteredBilling.length,
              itemBuilder: (context,index)=>BillingInfoTableBody(
                userId: filteredBilling[index].userID,
                name: filteredBilling[index].name,
                phone: filteredBilling[index].userPhone,
                billingNumber: filteredBilling[index].billingNumber,
                transactionId: filteredBilling[index].transactionId,
                billingMonth: filteredBilling[index].billingMonth,
                billingYear: filteredBilling[index].billingYear,
                payBy: filteredBilling[index].payBy,
                deductKey: filteredBilling[index].deductKey,
                payDate: filteredBilling[index].payDate,
                amount: filteredBilling[index].amount,
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
    ),
  );

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
