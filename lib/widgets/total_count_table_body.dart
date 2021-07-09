import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TotalCountTableBody extends StatefulWidget {
  String? month,year,debit,credit;

  TotalCountTableBody(
      {this.month, this.year, this.debit, this.credit});

  @override
  _TotalCountTableBodyState createState() => _TotalCountTableBodyState();
}

class _TotalCountTableBodyState extends State<TotalCountTableBody> {
  @override
  Widget build(BuildContext context) {
    String? billMonth;
    final Size size = MediaQuery.of(context).size;
    int debit=int.parse(widget.debit!);
    int credit=int.parse(widget.credit!);
    int profit=debit-credit;
    widget.month=='1'?billMonth='Jan':
    widget.month=='2'?billMonth='Feb':
    widget.month=='3'?billMonth='Mar':
    widget.month=='4'?billMonth='Apr':
    widget.month=='5'?billMonth='May':
    widget.month=='6'?billMonth='Jun':
    widget.month=='7'?billMonth='Jul':
    widget.month=='8'?billMonth='Aug':
    widget.month=='9'?billMonth='Sept':
    widget.month=='10'?billMonth='Oct':
    widget.month=='11'?billMonth='Nov':
    billMonth='Dec';
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _tableBodyBuilder(size, '$billMonth-${widget.year!}'),
              _tableBodyBuilder(size, widget.debit!),
              _tableBodyBuilder(size, widget.credit!),
              _tableBodyBuilder(size,'$profit'),
            ],
          ),
          SizedBox(height: 5.0),
          Divider(height: 5.0,thickness: 0.5,color: Colors.grey)
        ],
      ),
    );
  }

  Widget _tableBodyBuilder(Size size,String tableData){
    return Expanded(
      child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(),
          child: tableData.isNotEmpty? Text(
              tableData,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.grey.shade900,
                  fontSize: size.height*.021,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'OpenSans'
              ))
              :Container()
      ),
    );
  }

}
