import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_dish_admin_panlel/provider/head_provider.dart';
import 'package:new_dish_admin_panlel/provider/public_provider.dart';
import 'package:new_dish_admin_panlel/widgets/button_widget.dart';
import 'package:new_dish_admin_panlel/widgets/form_decoration.dart';
import 'package:provider/provider.dart';

class UpdateHead extends StatefulWidget {
  @override
  _UpdateHeadState createState() => _UpdateHeadState();
}

class _UpdateHeadState extends State<UpdateHead> {
  bool _isLoading=false;
  int _counter = 0;
  TextEditingController _title = TextEditingController(text: '');
  TextEditingController _name = TextEditingController(text: '');
  TextEditingController _details = TextEditingController(text: '');
  TextEditingController _debit = TextEditingController(text: '');
  TextEditingController _credit = TextEditingController(text: '');

  void _initializeData(PublicProvider publicProvider) {
    setState(() => _counter++);
    _title = TextEditingController(text: publicProvider.headModel.title);
    _name = TextEditingController(text: publicProvider.headModel.name);
    _details =
        TextEditingController(text: publicProvider.headModel.details);
    _debit =
        TextEditingController(text: publicProvider.headModel.debit);
    _credit = TextEditingController(text: publicProvider.headModel.credit);
  }
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final PublicProvider publicProvider = Provider.of<PublicProvider>(context);
    final HeadProvider auth = Provider.of<HeadProvider>(context);
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
                    'Update Record by Giving Updated Information',
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
                _textBuilder(size, 'Title', publicProvider),
                SizedBox(height: size.height * .04),
                Row(
                  children: [
                    Expanded(child: _textBuilder(size, 'Name', publicProvider)),
                    SizedBox(width: size.height * .04),
                    Expanded(
                        child: _textBuilder(size, 'Details', publicProvider)),
                  ],
                ),
                SizedBox(height: size.height * .04),

                Row(
                  children: [
                    Expanded(
                        child: _textBuilder(size, 'Debit', publicProvider)),
                    SizedBox(width: size.height * .04),
                    Expanded(
                        child:
                        _textBuilder(size, 'Credit', publicProvider)),
                  ],
                ),
                SizedBox(height: size.height * .04),

                SizedBox(height: size.height * .08),

                _isLoading
                    ? spinCircle()
                    : GradientButton(
                    child: Text('Update'),
                    onPressed: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      Future.delayed(Duration(seconds: 2), () async {
                        await auth
                            .updateHead('${publicProvider.headModel.id}', publicProvider)
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
          : hint == 'Title'
          ? _title
          : hint == 'Details'
          ? _details
          : hint == 'Debit'
          ? _debit
          : _credit,
      decoration: formDecoration(size).copyWith(
        labelText: hint,
        hintStyle: TextStyle(fontSize: 14),
        fillColor: Color(0xffF4F7F5),
      ),
      onChanged: (val) {
        setState(() {
          hint == 'Name'
              ? publicProvider.headModel.name = _name.text
              : hint == 'Title'
              ? publicProvider.headModel.title = _title.text
              : hint == 'Details'
              ? publicProvider.headModel.details = _details.text
              : hint == 'Debit'
              ? publicProvider.headModel.debit = _debit.text
              : publicProvider.headModel.credit = _credit.text;
        });
      },
    );
  }
}
