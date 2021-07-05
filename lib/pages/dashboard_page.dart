import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_dish_admin_panlel/provider/public_provider.dart';
import 'package:provider/provider.dart';

class DashBoardPage extends StatefulWidget {

  @override
  _DashBoardPageState createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  int _counter=0;
  bool _isLoading=true;

  // Future<void> _customInit(DoctorProvider doctorProvider)async{
  //   setState(()=>_counter++);
  //   await doctorProvider.getDoctor().then((value){
  //     setState(()=>_isLoading=false);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final PublicProvider publicProvider = Provider.of<PublicProvider>(context);
    // if(_counter==0) _customInit(doctorProvider);
    return Container(
      width: publicProvider.pageWidth(size),
      height: size.height,
      alignment: Alignment.center,
      child: GridView(
        scrollDirection: Axis.vertical,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: size.width<600
              ?1
              :size.width<700
              ?2
              :size.width<1300
              ?3
              :4,
          childAspectRatio: 1.3
        ),
        children: [
          _gridViewTile(size,'Customer',Color(0xff9D7CFD),
              'Total Customer','New Customer','10','50'),
          _gridViewTile(size,'Up To\nThis\nMonth',Color(0xff00B5C9),
              'Due Payment','Paid', '150','13'),
          _gridViewTile(size,'Customer\nProblems',Color(0xffFF8C00),
              'New','All','20','110'),
          _gridViewTile(size,'Payment\nRequest',Color(0xff00A958),
              'New Request','Total Request','50','200'),
          _gridViewTile(size,'Bill Man',Color(0xff00C4FE),
              'New Added','Total','05','10'),
        ],
      ),
    );
  }

  Widget _gridViewTile(Size size,String title, Color bgColor,
      String heading1, String heading2, String h1Data, String h2Data){
    return Stack(
      children: [
        Container(
          width: size.height*.5,
          height: size.height*.21,
          margin: EdgeInsets.only(top: size.height*.05,left: size.height*.02,right: size.height*.02),
          padding: EdgeInsets.symmetric(horizontal: size.height*.02,vertical: size.height*.02),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 5)
            ]
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(heading1,style: TextStyle(color: Colors.grey,
                      fontSize: size.height*.016,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'OpenSans'),),
                  Text(h1Data,style: TextStyle(color: Colors.grey[900],
                      fontSize: size.height*.022,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'OpenSans')),
                  SizedBox(height: size.height*.01),
                  Text(heading2,style: TextStyle(color: Colors.grey,
                      fontSize: size.height*.016,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'OpenSans'),),
                  Text(h2Data,style: TextStyle(color: Colors.grey[900],
                      fontSize: size.height*.022,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'OpenSans')),
                  Divider(height: 3,thickness: 0.2,color: Colors.grey),
                ],
              ),
              TextButton(
                  onPressed: (){},
                  child: Text('View All',
                      style: TextStyle(
                          fontSize: size.height*.016,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'OpenSans'))
              )
            ],
          ),
        ),
        Positioned(
          left: size.height*.04,
          top: size.height*.02,
          child: Container(
            height: size.height*.1,
            width: size.height*.1,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.all(Radius.circular(5)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade500,
                    blurRadius: 10,
                  )
                ]
            ),
            child: Text(title,
                textAlign: TextAlign.center,
                style:TextStyle(color: Colors.white,fontSize: size.height*.02,fontFamily: 'OpenSans') ),
          ),
        )
      ],
    );
  }
}

