import 'package:flutter/material.dart';
import 'package:new_dish_admin_panlel/provider/head_provider.dart';
import 'package:new_dish_admin_panlel/provider/public_provider.dart';
import 'package:new_dish_admin_panlel/widgets/button_widget.dart';
import 'package:new_dish_admin_panlel/widgets/form_decoration.dart';
import 'package:provider/provider.dart';

class AboutUsPage extends StatefulWidget {
  @override
  _AboutUsPageState createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  bool _isLoading=false;

  void _initializeData(HeadProvider auth) {
    auth.aboutModel.description = '';
  }


  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final PublicProvider publicProvider = Provider.of<PublicProvider>(context);
    final HeadProvider auth = Provider.of<HeadProvider>(context);
    if (auth.aboutModel.description == null) {
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
                  child: Text('Write Details Information About Dhaka Fiber LTD',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: size.height*.02,
                      color: Colors.grey.shade900,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.bold,
                    ),),
                ),
                SizedBox(height: size.height*.06),

                _textBuilder(size, 'About Dhaka Fiber Link LTD',auth),
                SizedBox(height: size.height*.08),

                _isLoading?spinCircle():GradientButton(
                    child: Text('Save') ,
                    onPressed: (){
                      _checkValidity(auth);
                    },
                    borderRadius: 5.0,
                    height: 40,
                    width: 250,
                    gradientColors: [
                      Color(0xff162B36),
                      Color(0xff006F64)
                    ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Future<void> _checkValidity(HeadProvider auth) async{
    if(auth.aboutModel.description!.isNotEmpty){
      setState(() {
        _isLoading=true;
      });
      Future.delayed(Duration(seconds: 2), ()async {
        bool result = await auth.writeAbout(auth.aboutModel);
        if(result){
          setState(() {
            _isLoading=false;
          });
        }
      });

    }else showToast('Complete all the required fields');
  }

  Widget _textBuilder(Size size, String hint,HeadProvider auth){
    return TextField(
      keyboardType: TextInputType.text,
      decoration: formDecoration(size).copyWith(
        labelText: hint,
        hintStyle: TextStyle(fontSize: 14),
        fillColor: Color(0xffF4F7F5),
      ),
      maxLines: 15,
      onChanged: (val){
        setState(() {
          auth.aboutModel.description=val;
        });
      },
    );
  }
}
