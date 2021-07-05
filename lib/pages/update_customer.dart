import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_dish_admin_panlel/provider/customer_provider.dart';
import 'package:new_dish_admin_panlel/provider/public_provider.dart';
import 'package:new_dish_admin_panlel/widgets/button_widget.dart';
import 'package:new_dish_admin_panlel/widgets/form_decoration.dart';
import 'package:provider/provider.dart';

class UpdateCustomer extends StatefulWidget {
  @override
  _UpdateCustomerState createState() => _UpdateCustomerState();
}

class _UpdateCustomerState extends State<UpdateCustomer> {
  bool _isLoading = false;
  int _counter = 0;
  String? _deductKey;
  String? _package;
  String? _activity;
  List<String> _deductList = ['Vat', 'AIT', 'Others'];
  List<String> _packageList = [
    'Package-1',
    'Package-2',
    'Package-3',
    'Package-4'
  ];
  List<String> _activityList = ['Active', 'Inactive'];

  TextEditingController _name = TextEditingController(text: '');
  TextEditingController _address = TextEditingController(text: '');
  TextEditingController _billAmount = TextEditingController(text: '');
  TextEditingController _phone = TextEditingController(text: '');

  void _initializeData(PublicProvider publicProvider) {
    setState(() => _counter++);
    _name = TextEditingController(text: publicProvider.customerModel.name);
    _address =
        TextEditingController(text: publicProvider.customerModel.address);
    _billAmount =
        TextEditingController(text: publicProvider.customerModel.billAmount);
    _phone = TextEditingController(text: publicProvider.customerModel.phone);
    _deductKey = publicProvider.customerModel.deductKey;
    _package = publicProvider.customerModel.package;
    _activity = publicProvider.customerModel.activity;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final PublicProvider publicProvider = Provider.of<PublicProvider>(context);
    final CustomerProvider auth = Provider.of<CustomerProvider>(context);
    if (_counter == 0) _initializeData(publicProvider);
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
                    'Update Customer by Giving Updated Information',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: size.height * .02,
                      color: Colors.grey.shade900,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: size.height * .08),
                Container(
                  width: size.width * .3,
                  padding: EdgeInsets.symmetric(
                      horizontal: 10, vertical: size.height * .01),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueGrey, width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      isDense: true,
                      isExpanded: true,
                      value: _activity,
                      hint: Text('Select Activity',
                          style: TextStyle(
                            color: Colors.grey,
                            fontFamily: 'OpenSans',
                            fontSize: size.height * .022,
                          )),
                      items: _activityList.map((category) {
                        return DropdownMenuItem(
                          child: Text(
                            category,
                            style: TextStyle(
                                color: Colors.grey[900],
                                fontSize: size.height * .022,
                                fontFamily: 'OpenSans'),
                          ),
                          value: category,
                        );
                      }).toList(),
                      onChanged: (newVal) {
                        setState(() {
                          _activity = newVal as String;
                          publicProvider.customerModel.activity = _activity;
                        });
                      },
                      dropdownColor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: size.height * .04),
                Row(
                  children: [
                    Expanded(child: _textBuilder(size, 'Name', publicProvider)),
                    SizedBox(width: size.height * .04),
                    Expanded(
                        child: _textBuilder(size, 'Address', publicProvider)),
                  ],
                ),
                SizedBox(height: size.height * .04),

                Row(
                  children: [
                    Expanded(
                        child: _textBuilder(size, 'Phone', publicProvider)),
                    SizedBox(width: size.height * .04),
                    Expanded(
                        child:
                            _textBuilder(size, 'Bill Amount', publicProvider)),
                  ],
                ),
                SizedBox(height: size.height * .04),

                Row(
                  children: [
                    ///Deduct Key Dropdown
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10, vertical: size.height * .01),
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.blueGrey, width: 1),
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            isDense: true,
                            isExpanded: true,
                            value: _deductKey,
                            hint: Text('Select Deduct Key',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'OpenSans',
                                  fontSize: size.height * .022,
                                )),
                            items: _deductList.map((category) {
                              return DropdownMenuItem(
                                child: Text(
                                  category,
                                  style: TextStyle(
                                      color: Colors.grey[900],
                                      fontSize: size.height * .022,
                                      fontFamily: 'OpenSans'),
                                ),
                                value: category,
                              );
                            }).toList(),
                            onChanged: (newVal) {
                              setState(() {
                                _deductKey = newVal as String;
                                publicProvider.customerModel.deductKey = _deductKey;
                              });
                            },
                            dropdownColor: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: size.height * .04),

                    ///Package Dropdown
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10, vertical: size.height * .01),
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.blueGrey, width: 1),
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            isDense: true,
                            isExpanded: true,
                            value: _package,
                            hint: Text('Select Package',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'OpenSans',
                                  fontSize: size.height * .022,
                                )),
                            items: _packageList.map((category) {
                              return DropdownMenuItem(
                                child: Text(
                                  category,
                                  style: TextStyle(
                                      color: Colors.grey[900],
                                      fontSize: size.height * .022,
                                      fontFamily: 'OpenSans'),
                                ),
                                value: category,
                              );
                            }).toList(),
                            onChanged: (newVal) {
                              setState(() {
                                _package = newVal as String;
                                publicProvider.customerModel.package = _package;
                              });
                            },
                            dropdownColor: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: size.height * .08),

                _isLoading
                    ? spinCircle()
                    : GradientButton(
                        child: Text('Update Customer'),
                        onPressed: () async {
                          setState(() {
                            _isLoading = true;
                          });
                          Future.delayed(Duration(seconds: 2), () async {
                            await auth
                                .updateCustomer(
                                    '${publicProvider.customerModel.id}',
                                    publicProvider)
                                .then((value) {
                              setState(() {
                                _isLoading = false;
                              });
                            });
                          });
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

  Widget _textBuilder(Size size, String hint, PublicProvider publicProvider) {
    return TextField(
      controller: hint == "Name"
          ? _name
          : hint == 'Address'
              ? _address
              : hint == 'Bill Amount'
                  ? _billAmount
                  : hint == 'Phone'
                      ? _phone
                      : null,
      keyboardType: hint == 'Phone'
          ? TextInputType.phone
          : hint == 'Bill Amount'
              ? TextInputType.number
              : TextInputType.text,
      decoration: formDecoration(size).copyWith(
        labelText: hint,
        hintStyle: TextStyle(fontSize: 14),
        fillColor: Color(0xffF4F7F5),
      ),
      onChanged: (val) {
        setState(() {
          hint == 'Name'
              ? publicProvider.customerModel.name = _name.text
              : hint == 'Address'
                  ? publicProvider.customerModel.address = _address.text
                  : hint == 'Bill Amount'
                      ? publicProvider.customerModel.billAmount =
                          _billAmount.text
                      : publicProvider.customerModel.phone = _phone.text;
        });
      },
    );
  }
}
