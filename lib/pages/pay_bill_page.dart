import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_dish_admin_panlel/model/head_of_account_model.dart';
import 'package:new_dish_admin_panlel/provider/billing_provider.dart';
import 'package:new_dish_admin_panlel/provider/customer_provider.dart';
import 'package:new_dish_admin_panlel/provider/head_provider.dart';
import 'package:new_dish_admin_panlel/provider/public_provider.dart';
import 'package:new_dish_admin_panlel/widgets/button_widget.dart';
import 'package:new_dish_admin_panlel/widgets/form_decoration.dart';
import 'package:provider/provider.dart';

class PayBill extends StatefulWidget {
  @override
  _PayBillState createState() => _PayBillState();
}

class _PayBillState extends State<PayBill> {
  String payDate = DateFormat("yyyy-MM-dd").format(
      DateTime.fromMillisecondsSinceEpoch(
          DateTime.now().millisecondsSinceEpoch));
  String? _deductKey;
  bool _isLoading = false;
  DateTime? _date;
  DateTime? currentMonth;
  DateTime? billMonth;
  var months;
  String? _payBy;
  String? _headOfAccount;
  List<dynamic> headAccounts = [];
  final _addKey = GlobalKey<FormState>();
  TextEditingController _payDate = TextEditingController(text: '');
  List<String> _deductList = ['Vat','AIT','Others'];
  List<String> _payList = ['Bank','Cash'];

  void _initializeData(BillingProvider auth,PublicProvider publicProvider) {
    auth.billingInfoModel.payBy = '';
    auth.billingInfoModel.billingNumber = '';
    auth.billingInfoModel.transactionId = '';
    _payDate = TextEditingController(text: payDate);
    auth.billingInfoModel.payDate=payDate;
    auth.billingInfoModel.name=publicProvider.customerModel.name;
    auth.billingInfoModel.userPhone=publicProvider.customerModel.phone;
    auth.billingInfoModel.userID='${publicProvider.customerModel.id}';
    auth.billingInfoModel.amount=publicProvider.customerModel.billAmount;
  }

  _initializeDate() {
    setState(() {
      _date = DateTime.now();
      // _filterList('${_date.month}/${_date.year}');
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
    final BillingProvider auth = Provider.of<BillingProvider>(context);
    final CustomerProvider customerProvider = Provider.of<CustomerProvider>(context);
    final HeadProvider headProvider = Provider.of<HeadProvider>(context);
    if (auth.billingInfoModel.payBy == null ||
        auth.billingInfoModel.amount == null) {
      _initializeData(auth,publicProvider);
      _initializeDate();
    }
    setState(() {
      headAccounts=headProvider.headOfAccountBillList;
    });
    return Container(
      width: publicProvider.pageWidth(size),
      child: Center(
        child: Container(
          height: size.height * .7,
          width: size.width * .7,
          padding: EdgeInsets.symmetric(horizontal: 50),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ///Heading Text
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Text(
                    'Pay bill by Giving Detailed Information',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: size.height * .023,
                      color: Colors.grey.shade900,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: size.height * .04),
                Container(
                  width: size.width,
                  height: 20,
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: [
                      SizedBox(width: size.width * .05),
                      Text('Client\'s info: ',
                          style: TextStyle(
                            fontSize: size.height * .021,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade900,
                          )),
                      Text('${publicProvider.customerModel.id ?? ''}',
                          style: TextStyle(
                            fontSize: size.height * .021,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade900,
                          )),
                      Text(' | '),
                      Text(publicProvider.customerModel.name ?? '',
                          style: TextStyle(
                            fontSize: size.height * .021,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade900,
                          )),
                      Text(' | '),
                      Text(publicProvider.customerModel.phone ?? '',
                          style: TextStyle(
                            fontSize: size.height * .021,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade900,
                          )),
                      Text(' | '),
                      Text(publicProvider.customerModel.address ?? '',
                          style: TextStyle(
                            fontSize: size.height * .021,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade900,
                          )),
                      Text(' | '),
                      Text(publicProvider.customerModel.package ?? '',
                          style: TextStyle(
                            fontSize: size.height * .021,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade900,
                          )),
                      Text(' | '),
                      Text(publicProvider.customerModel.billAmount ?? '',
                          style: TextStyle(
                            fontSize: size.height * .021,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade900,
                          )),
                      Text(' | '),
                      Text(publicProvider.customerModel.activity ?? '',
                          style: TextStyle(
                            fontSize: size.height * .021,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade900,
                          )),
                    ],
                  ),
                ),
                SizedBox(height: size.height * .03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: size.width * .05),
                    Container(
                        height: 50,
                        width: size.width * .07,
                        child: Center(
                            child: Text(
                          'Due Amount: ',
                          style: TextStyle(
                            fontSize: size.height * .021,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade900,
                          ),
                        ))),
                    Container(
                      height: 40,
                      width: size.width * .07,
                      child: Center(
                          child: Text(
                              '৳ ${publicProvider.customerModel.dueAmount ?? ''}',
                              style: TextStyle(
                                fontSize: size.height * .021,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade900,
                              ))),
                    )
                  ],
                ),
                SizedBox(height: size.height * .03),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        width: size.width * 5,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                height: 50,
                                width: size.width * .07,
                                child: Center(
                                    child: Text(
                                      'Pay By: ',
                                      style: TextStyle(fontSize: size.height * .02),
                                    ))),
                            Container(
                              height: 40,
                              width: size.width * .15,
                              padding: EdgeInsets.symmetric(horizontal: 10,vertical: size.height*.01),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.blueGrey,width: 1),
                                  borderRadius: BorderRadius.all(Radius.circular(5))
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  isDense: true,
                                  isExpanded: true,
                                  value:_payBy,
                                  hint: Text('Select Pay method',style: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: 'OpenSans',
                                    fontSize: size.height*.022,)),
                                  items:_payList.map((category){
                                    return DropdownMenuItem(
                                      child: Text(category, style: TextStyle(
                                          color: Colors.grey[900],
                                          fontSize: size.height * .022,fontFamily: 'OpenSans'
                                      ),
                                      ),
                                      value: category,
                                    );
                                  }).toList(),
                                  onChanged: (newVal){
                                    setState(() {
                                      _payBy = newVal as String;
                                      auth.billingInfoModel.payBy=_payBy;
                                    });
                                    headProvider.getCurrentExpenses('${DateTime.now().month}-${DateTime.now().year}Bill');
                                  },

                                  dropdownColor: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    _payBy=='Bank'?Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              height: 50,
                              width: size.width * .07,
                              child: Center(
                                  child: Text(
                                    'Head:  ',
                                    style: TextStyle(fontSize: size.height * .02),
                                  ))),
                          Container(
                            width: size.width*.14,
                            padding: EdgeInsets.symmetric(horizontal: 10,vertical: size.height*.01),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.blueGrey,width: 1),
                                borderRadius: BorderRadius.all(Radius.circular(5))
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                isDense: true,
                                isExpanded: true,
                                value:_headOfAccount,
                                hint: Text('Select Accounts Head',style: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'OpenSans',
                                  fontSize: size.height*.022,)),
                                items:headAccounts.map((category){
                                  return DropdownMenuItem(
                                    child: Text(category.name, style: TextStyle(
                                        color: Colors.grey[900],
                                        fontSize: size.height * .022,fontFamily: 'OpenSans'
                                    )),
                                    value: category.name.toString(),
                                  );
                                }).toList(),
                                onChanged: (newVal){
                                  setState(() {
                                    _headOfAccount = newVal as String;
                                    headProvider.headModel.headOfAccount=_headOfAccount;
                                  });
                                  headProvider.getCurrentExpenses('${DateTime.now().month}-${DateTime.now().year}${headProvider.headModel.headOfAccount}');
                                },
                                dropdownColor: Colors.white,
                              ),
                            ),
                          ),
                          IconButton(icon: Icon(Icons.add_circle),onPressed: (){
                            _showDialog(headProvider, publicProvider);
                          },),
                        ],
                      ),
                    ):Container(),
                  ],
                ),
                SizedBox(height: size.height * .04),
                ///Deduct Key Dropdown
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        width: size.width * 5,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                height: 50,
                                width: size.width * .07,
                                child: Center(
                                    child: Text(
                                      'Deduct Key: ',
                                      style: TextStyle(fontSize: size.height * .02),
                                    ))),
                            Container(
                              height: 40,
                              width: size.width * .15,
                              padding: EdgeInsets.symmetric(horizontal: 10,vertical: size.height*.01),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.blueGrey,width: 1),
                                  borderRadius: BorderRadius.all(Radius.circular(5))
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  isDense: true,
                                  isExpanded: true,
                                  value:_deductKey,
                                  hint: Text('Select Deduct Key',style: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: 'OpenSans',
                                    fontSize: size.height*.022,)),
                                  items:_deductList.map((category){
                                    return DropdownMenuItem(
                                      child: Text(category, style: TextStyle(
                                          color: Colors.grey[900],
                                          fontSize: size.height * .022,fontFamily: 'OpenSans'
                                      ),
                                      ),
                                      value: category,
                                    );
                                  }).toList(),
                                  onChanged: (newVal){
                                    setState(() {
                                      _deductKey = newVal as String;
                                      auth.billingInfoModel.deductKey=_deductKey;
                                    });
                                  },

                                  dropdownColor: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: size.width * 5,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                height: 50,
                                width: size.width * .07,
                                child: Center(
                                    child: Text(
                                      'Billing Month: ',
                                      style: TextStyle(fontSize: size.height * .02),
                                    ))),
                            InkWell(
                              onTap: () {
                                _pickDate(context);
                              },
                              child: Container(
                                height: 40,
                                width: size.width * .15,
                                padding: EdgeInsets.symmetric(
                                    horizontal: size.height * .01,
                                    vertical: size.height * .011),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                                child: Text('${_date!.year}-${_date!.month}',
                                    style: TextStyle(
                                        fontSize: size.height * .02,
                                        color: Colors.grey.shade900,
                                        fontFamily: 'OpenSans')),
                              ),
                              //borderRadius: BorderRadius.all(Radius.circular(5))
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.height * .04),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        width: size.width * 5,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                height: 50,
                                width: size.width * .07,
                                child: Center(
                                    child: Text(
                                  'Amount: ',
                                  style: TextStyle(fontSize: size.height * .02),
                                ))),
                            Container(
                              height: 40,
                              width: size.width * .15,
                              child: Center(
                                child: TextField(
                                  keyboardType: TextInputType.text,
                                  decoration: formDecoration(size).copyWith(
                                    fillColor: Color(0xffF4F7F5),
                                  ),
                                  onChanged: (val) {
                                    setState(() {
                                      auth.billingInfoModel.amount = val;
                                    });
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: size.width * 5,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                height: 50,
                                width: size.width * .07,
                                child: Center(
                                    child: Text(
                                  'Payment Date: ',
                                  style: TextStyle(fontSize: size.height * .02),
                                ))),
                            Container(
                              height: 40,
                              width: size.width * .15,
                              child: Center(
                                child: TextField(
                                  enabled: false,
                                  controller: _payDate,
                                  decoration: formDecoration(size).copyWith(
                                    fillColor: Color(0xffF4F7F5),
                                  ),
                                  onChanged: (val) {
                                    setState(() {
                                      auth.billingInfoModel.payDate = _payDate.text;
                                    });
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.height * .08),

                _isLoading
                    ? spinCircle()
                    : GradientButton(
                        child: Text('Pay bill'),
                        onPressed: () {
                          _checkValidity(auth,publicProvider,customerProvider,headProvider);
                        },
                        borderRadius: 5.0,
                        height: 40,
                        width: 250,
                        gradientColors: [Color(0xff162B36), Color(0xff006F64)])
              ],
            ),
          ),
        ),
      ),
    );
  }

  _showDialog(HeadProvider headProvider,PublicProvider publicProvider) {
    String? name;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            scrollable: true,
            contentPadding: EdgeInsets.all(20),
            title: Text(
              "Add Head of Account",
              textAlign: TextAlign.center,
            ),
            content: Container(
              child: Form(
                key: _addKey,
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    TextFormField(
                      maxLines: 2,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(hintText: 'Write head of account'),
                      onSaved: (val) {
                        name = val!;
                      },
                      validator: (val) =>
                      val!.isEmpty ? 'please write head of account' : null,
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RaisedButton(
                          color: Colors.redAccent,
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        RaisedButton(
                          color: Theme.of(context).primaryColor,
                          onPressed: () {
                            Navigator.of(context).pop();
                            showToast('Please wait..');
                            if (_addKey.currentState!.validate()) {
                              _addKey.currentState!.save();
                              HeadOfAccountModel ap = HeadOfAccountModel();
                              setState(() {
                                ap.name = name;
                                headProvider.addHeadOfAccountBill(ap);
                              });
                              //Navigator.of(context).pop();
                            }
                          },
                          child: Text(
                            "Add",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
  Future<void> _checkValidity(BillingProvider auth,PublicProvider publicProvider,CustomerProvider customerProvider,HeadProvider headProvider) async {
   //publicProvider.customerModel.dueAmount=null;
    setState(() {
      currentMonth = DateTime.utc(DateTime.now().year, DateTime.now().month);

      billMonth = DateTime.utc(_date!.year, _date!.month);
    });
    var years = currentMonth!.difference(billMonth!);
    months = years.inDays ~/ 30;
    int due=int.parse(auth.billingInfoModel.amount!);
    num dueNum=due*months;
    String dueAmount='$dueNum';
    if(_payBy=='Bank'){
      if (auth.billingInfoModel.payBy!.isNotEmpty && headProvider.headModel.headOfAccount!.isNotEmpty && auth.billingInfoModel.amount!=null) {
        setState(() {
          headProvider.headModel.credit=auth.billingInfoModel.amount;
          headProvider.headModel.debit='0';
          headProvider.headModel.name='Bill';
          headProvider.headModel.details='Bill credited by bank';
          auth.billingInfoModel.transactionId = 'None';
          auth.billingInfoModel.billingNumber = 'None';
          auth.billingInfoModel.billingMonth = '${_date!.month}';
          auth.billingInfoModel.billingYear = '${_date!.year}';
          publicProvider.customerModel.lastEntryMonth='${_date!.month}';
          publicProvider.customerModel.lastEntryYear='${_date!.year}';
          publicProvider.customerModel.dueAmount=dueAmount;
          dueAmount=='0'?publicProvider.customerModel.billState='paid':publicProvider.customerModel.billState='due';
        });
        setState(() {
          _isLoading = true;
        });
        final snapShot = await FirebaseFirestore.instance
            .collection('Expenses')
            .doc('${DateTime.now().month}-${DateTime.now().year}${headProvider.headModel.headOfAccount}') // varuId in your case
            .get();
        Future.delayed(Duration(seconds: 2), () async {
          await auth.payBill(auth.billingInfoModel,headProvider,customerProvider).then((value){
            customerProvider.updateCustomerState(publicProvider.customerModel.id!, publicProvider).then((value){
              if(!snapShot.exists){
                headProvider.addBankBookDetails(headProvider.headModel);
              }else{
                headProvider.addBankBookDetails2(headProvider.headModel,headProvider.currentExpenseList[0].totalCost);
              }

            });
            setState(() {
              _isLoading = false;
            });
          });

        });
      } else
        showToast('Complete all the required fields');
    }else{
      if (auth.billingInfoModel.payBy!.isNotEmpty && auth.billingInfoModel.amount!=null) {
        setState(() {
          headProvider.headModel.headOfAccount='Bill';
          headProvider.headModel.credit=auth.billingInfoModel.amount;
          headProvider.headModel.debit='0';
          headProvider.headModel.name='Bill';
          headProvider.headModel.details='Bill credited by cash';
          auth.billingInfoModel.transactionId = 'None';
          auth.billingInfoModel.billingNumber = 'None';
          auth.billingInfoModel.billingMonth = '${_date!.month}';
          auth.billingInfoModel.billingYear = '${_date!.year}';
          publicProvider.customerModel.lastEntryMonth='${_date!.month}';
          publicProvider.customerModel.lastEntryYear='${_date!.year}';
          publicProvider.customerModel.dueAmount=dueAmount;
          dueAmount=='0'?publicProvider.customerModel.billState='paid':publicProvider.customerModel.billState='due';
        });
        setState(() {
          _isLoading = true;
        });
        final snapShot = await FirebaseFirestore.instance
            .collection('Expenses')
            .doc('${DateTime.now().month}-${DateTime.now().year}Bill')
            .get();
        Future.delayed(Duration(seconds: 2), () async {
          await auth.payBill(auth.billingInfoModel,headProvider,customerProvider).then((value){
            customerProvider.updateCustomerState(publicProvider.customerModel.id!, publicProvider).then((value){
              if(!snapShot.exists){
                headProvider.addCashBookDetails(headProvider.headModel);
              }else{
                headProvider.addCashBookDetails2(headProvider.headModel,headProvider.currentExpenseList[0].totalCost);
              }
            });
            setState(() {
              _isLoading = false;
            });
          });

        });
      } else
        showToast('Complete all the required fields');
    }

  }
}
