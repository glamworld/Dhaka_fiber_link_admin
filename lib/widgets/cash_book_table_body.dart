import 'package:flutter/material.dart';
import 'package:new_dish_admin_panlel/provider/public_provider.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class CashBookTableBody extends StatefulWidget {
  String? headOfAccount,name,details,debit,credit,month,year;
  CashBookTableBody({this.headOfAccount, this.name, this.details, this.debit, this.credit,this.month,this.year});

  @override
  _CashBookTableBodyState createState() => _CashBookTableBodyState();
}

class _CashBookTableBodyState extends State<CashBookTableBody> {
  @override
  Widget build(BuildContext context) {
    String? billMonth;
    final Size size = MediaQuery.of(context).size;
    final PublicProvider publicProvider  = Provider.of<PublicProvider>(context);
    setState(() {
      widget.month=='01'?billMonth='Jan':
      widget.month=='02'?billMonth='Feb':
      widget.month=='03'?billMonth='Mar':
      widget.month=='04'?billMonth='Apr':
      widget.month=='05'?billMonth='May':
      widget.month=='06'?billMonth='Jun':
      widget.month=='07'?billMonth='Jul':
      widget.month=='08'?billMonth='Aug':
      widget.month=='09'?billMonth='Sept':
      widget.month=='10'?billMonth='Oct':
      widget.month=='11'?billMonth='Nov':
      billMonth='Dec';
    });

    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _tableBodyBuilder(size, '$billMonth-${widget.year!}', publicProvider),
              _tableBodyBuilder(size, widget.headOfAccount!, publicProvider),
              _tableBodyBuilder(size, widget.name!, publicProvider),
              _tableBodyBuilder(size, widget.details!, publicProvider),
              _tableBodyBuilder(size,widget.debit!,publicProvider),
              _tableBodyBuilder(size,widget.credit!,publicProvider),
            ],
          ),
          SizedBox(height: 5.0),
          Divider(height: 5.0,thickness: 0.5,color: Colors.grey)
        ],
      ),
    );
  }

  Widget _tableBodyBuilder(Size size,String tableData,PublicProvider publicProvider){
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        child:tableData.isNotEmpty
            ?Text(
            '$tableData',// $index',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: tableData=='Active'
                    ?Color(0xff006F64)
                    :tableData=='Inactive'
                    ? Colors.deepOrange
                    : Colors.grey.shade900,
                fontSize: size.height*.021,
                fontWeight: FontWeight.w400,
                fontFamily: 'OpenSans'
            ))
            :Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Color(0xff006F64))),
              child: Text('Update',
                  style: TextStyle(fontSize: size.height*.015,fontFamily: 'OpenSans',color: Colors.white)),
              onPressed: (){
                // publicProvider.category= publicProvider.subCategory;
                // publicProvider.subCategory='Pay Bill';
              },
            ),
            SizedBox(width: size.height*.03),
            ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Color(0xffF0A732))),
              child: Text('Delete',
                  style: TextStyle(fontSize: size.height*.015,fontFamily: 'OpenSans',color: Colors.white)),
              onPressed: (){
                // publicProvider.category= publicProvider.subCategory;
                // publicProvider.subCategory='Pay Bill';
              },
            ),
            SizedBox(width: size.height*.02),

          ],
        ),
      ),
    );
  }
}
