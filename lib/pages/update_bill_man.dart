import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_dish_admin_panlel/provider/bill_man_provider.dart';
import 'package:new_dish_admin_panlel/provider/public_provider.dart';
import 'package:new_dish_admin_panlel/widgets/button_widget.dart';
import 'package:new_dish_admin_panlel/widgets/form_decoration.dart';
import 'package:provider/provider.dart';

class UpdateBillMan extends StatefulWidget {
  @override
  _UpdateBillManState createState() => _UpdateBillManState();
}

class _UpdateBillManState extends State<UpdateBillMan> {
  bool _isLoading = false;
  int _counter = 0;

  TextEditingController _name = TextEditingController(text: '');
  TextEditingController _address = TextEditingController(text: '');
  TextEditingController _password = TextEditingController(text: '');
  TextEditingController _phone = TextEditingController(text: '');

  void _initializeData(PublicProvider publicProvider) {
    setState(() => _counter++);
    _name = TextEditingController(text: publicProvider.billManModel.name);
    _address =
        TextEditingController(text: publicProvider.billManModel.address);
    _password =
        TextEditingController(text: publicProvider.billManModel.password);
    _phone = TextEditingController(text: publicProvider.billManModel.phone);
  }
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final PublicProvider publicProvider = Provider.of<PublicProvider>(context);
    final BillManProvider auth = Provider.of<BillManProvider>(context);
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
                    'Update BillMan by Giving Updated Information',
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
                        _textBuilder(size, 'Password', publicProvider)),
                  ],
                ),
                SizedBox(height: size.height * .04),

                SizedBox(height: size.height * .08),

                _isLoading
                    ? spinCircle()
                    : GradientButton(
                    child: Text('Update BillMan'),
                    onPressed: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      Future.delayed(Duration(seconds: 2), () async {
                        await auth
                            .updateBillMan(
                            '${publicProvider.billManModel.id}',
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
          : hint == 'Password'
          ? _password
          : hint == 'Phone'
          ? _phone
          : null,
      keyboardType: hint == 'Phone'
          ? TextInputType.phone
          : TextInputType.text,
      decoration: formDecoration(size).copyWith(
        labelText: hint,
        hintStyle: TextStyle(fontSize: 14),
        fillColor: Color(0xffF4F7F5),
      ),
      onChanged: (val) {
        setState(() {
          hint == 'Name'
              ? publicProvider.billManModel.name = _name.text
              : hint == 'Address'
              ? publicProvider.billManModel.address = _address.text
              : hint == 'Password'
              ? publicProvider.billManModel.password = _password.text
              : publicProvider.billManModel.phone = _phone.text;
        });
      },
    );
  }
}
