import 'package:flutter/material.dart';
import 'package:new_dish_admin_panlel/provider/customer_provider.dart';
import 'package:new_dish_admin_panlel/provider/public_provider.dart';
import 'package:new_dish_admin_panlel/widgets/button_widget.dart';
import 'package:new_dish_admin_panlel/widgets/form_decoration.dart';
import 'package:provider/provider.dart';
import '../widgets/form_decoration.dart';

class AddNewCustomer extends StatefulWidget {

  @override
  _AddNewCustomerState createState() => _AddNewCustomerState();
}

class _AddNewCustomerState extends State<AddNewCustomer> {
  bool _isLoading=false;

  String? _package;
  List<String> _packageList = ['Package-1','Package-2','Package-3', 'Package-4'];
  void _initializeData(CustomerProvider auth) {
    auth.customerModel.name = '';
    auth.customerModel.address = '';
    auth.customerModel.billAmount = '';
    auth.customerModel.phone = '';
  }

  // TextEditingController _name = TextEditingController(text: '');
  // TextEditingController _address = TextEditingController(text: '');
  // TextEditingController _billAmount = TextEditingController(text: '');
  // TextEditingController _phone = TextEditingController(text: '');
  
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final PublicProvider publicProvider = Provider.of<PublicProvider>(context);
    final CustomerProvider auth = Provider.of<CustomerProvider>(context);
    if (auth.customerModel.name == null ||
        auth.customerModel.billAmount == null) {
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
                  child: Text('Add New Customer by Giving Detailed Information',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: size.height*.02,
                    color: Colors.grey.shade900,
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.bold,
                  ),),
                ),
                SizedBox(height: size.height*.05),
                ///Package Dropdown
                Container(
                  width: size.width*.3,
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: size.height*.01),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueGrey,width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(5))
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      isDense: true,
                      isExpanded: true,
                      value:_package,
                      hint: Text('Select Package',style: TextStyle(
                        color: Colors.grey,
                        fontFamily: 'OpenSans',
                        fontSize: size.height*.022,)),
                      items:_packageList.map((category){
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
                          _package = newVal as String;
                          auth.customerModel.package=_package;
                        });
                      },
                      dropdownColor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: size.height*.04),
                Row(
                  children: [
                    Expanded(child: _textBuilder(size, 'Name',auth)),
                    SizedBox(width: size.height*.04),
                    Expanded(child: _textBuilder(size, 'Address',auth)),
                  ],
                ),
                SizedBox(height: size.height*.04),

                Row(
                  children: [
                    Expanded(child: _textBuilder(size, 'Phone',auth)),
                    SizedBox(width: size.height*.04),
                    Expanded(child: _textBuilder(size, 'Password',auth)),
                  ],
                ),
                SizedBox(height: size.height*.04),

                Row(
                  children: [
                    Expanded(child: _textBuilder(size, 'Bill Amount',auth)),
                    SizedBox(width: size.height*.04),
                    Expanded(child: _textBuilder(size, 'Installation fee',auth)),

                  ],
                ),


                SizedBox(height: size.height*.08),

                _isLoading?spinCircle():GradientButton(
                    child: Text('Add Customer'),
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

  Future<void> _checkValidity(CustomerProvider auth) async{
      if(auth.customerModel.name!.isNotEmpty && auth.customerModel.phone!.isNotEmpty && auth.customerModel.password!.isNotEmpty && auth.customerModel.billAmount!.isNotEmpty &&
          auth.customerModel.address!.isNotEmpty && auth.customerModel.installationFee!=null &&auth.customerModel.package!=null){
        setState(() {
          _isLoading=true;
        });

        final num id =100+auth.customerList.length+1;
        Future.delayed(Duration(seconds: 2), ()async {
          bool result = await auth.addNewCustomer(auth.customerModel,id);
          if(result){
            setState(() {
              _isLoading=false;
            });
          }
        });

      }else showToast('Complete all the required fields');
  }

  Widget _textBuilder(Size size, String hint,CustomerProvider auth){
    return TextField(
      keyboardType: hint=='Phone'? TextInputType.phone
          :hint=='Bill Amount'?TextInputType.number
          :TextInputType.text,
      decoration: formDecoration(size).copyWith(
        labelText: hint,
        hintStyle: TextStyle(fontSize: 14),
        fillColor: Color(0xffF4F7F5),
      ),
      onChanged: (val){
        setState(() {
          hint=='Name'? auth.customerModel.name=val
              :hint=='Address'? auth.customerModel.address=val
              :hint=='Bill Amount'?auth.customerModel.billAmount=val
              :hint=='Password'?auth.customerModel.password=val
              :hint=='Installation fee'?auth.customerModel.installationFee=val
              :auth.customerModel.phone=val;
        });
      },
    );
  }
}
