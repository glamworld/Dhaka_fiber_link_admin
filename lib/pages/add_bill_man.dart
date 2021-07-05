import 'package:flutter/material.dart';
import 'package:new_dish_admin_panlel/provider/bill_man_provider.dart';
import 'package:new_dish_admin_panlel/provider/public_provider.dart';
import 'package:new_dish_admin_panlel/widgets/button_widget.dart';
import 'package:new_dish_admin_panlel/widgets/form_decoration.dart';
import 'package:provider/provider.dart';

class AddBillMan extends StatefulWidget {

  @override
  _AddBillManState createState() => _AddBillManState();
}

class _AddBillManState extends State<AddBillMan> {
  bool _isLoading=false;
  void _initializeData(BillManProvider auth) {
    auth.billManModel.name = '';
    auth.billManModel.address = '';
    auth.billManModel.phone = '';
    auth.billManModel.password = '';
  }

  // TextEditingController _name = TextEditingController(text: '');
  // TextEditingController _address = TextEditingController(text: '');
  // TextEditingController _phone = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final PublicProvider publicProvider = Provider.of<PublicProvider>(context);
    final BillManProvider auth = Provider.of<BillManProvider>(context);
    if (auth.billManModel.name == null ||
        auth.billManModel.phone == null) {
      _initializeData(auth);
    }
    return Container(
      width: publicProvider.pageWidth(size),
      child: Center(
        child: Container(
          height: size.height*.7,
          width: size.width*.7,
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
                  padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                  child: Text('Add New Bill Man by Giving Detailed Information',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: size.height*.02,
                      color: Colors.grey.shade900,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.bold,
                    ),),
                ),
                SizedBox(height: size.height*.08),

                Row(
                  children: [
                    Expanded(child: _textBuilder(size, 'Name',auth)),
                    SizedBox(width: size.height*.04),
                    Expanded(child: _textBuilder(size, 'Phone Number',auth)),
                  ],
                ),
                SizedBox(height: size.height*.04),

                Row(
                  children: [
                    Expanded(child: _textBuilder(size, 'Password',auth)),
                    SizedBox(width: size.height*.04),
                    Expanded(child: _textBuilder(size, 'Address',auth)),
                  ],
                ),
                SizedBox(height: size.height*.04),


                SizedBox(height: size.height*.08),

                _isLoading?spinCircle():GradientButton(
                    child: Text('Add Bill Man'),
                    onPressed: (){
                      _checkValidity(auth);
                    },
                    borderRadius: 5.0,
                    height: 40,
                    width: 250,
                    gradientColors: [
                      Color(0xff162B36),
                      Color(0xff006F64)
                    ])
              ],
            ),
          ),
        ),
      ),
    );
  }
  Future<void> _checkValidity(BillManProvider auth) async{
    if(auth.billManModel.name!.isNotEmpty && auth.billManModel.phone!.isNotEmpty && auth.billManModel.address!.isNotEmpty &&
        auth.billManModel.password!.isNotEmpty){
      setState(() {
        _isLoading=true;
      });
      Future.delayed(Duration(seconds: 2), ()async {
        bool result = await auth.addNewBillMan(auth.billManModel);
        if(result){
          setState(() {
            _isLoading=false;
          });
        }
      });

    }else showToast('Complete all the required fields');
  }

  Widget _textBuilder(Size size, String hint,BillManProvider billManProvider){
    return TextField(
      // controller: hint=='Name'
      //     ?_name
      //     : hint=='Address'
      //     ?_address
      //     :_phone,
      decoration: formDecoration(size).copyWith(
        labelText: hint,
        hintStyle: TextStyle(fontSize: 14),
        fillColor: Color(0xffF4F7F5),
      ),
      onChanged: (val){
        setState(() {
          hint=='Name'? billManProvider.billManModel.name=val
              :hint=='Address'? billManProvider.billManModel.address=val
              :hint=='Phone Number'?billManProvider.billManModel.phone=val
              :billManProvider.billManModel.password=val;
        });
      },
    );
  }
}
