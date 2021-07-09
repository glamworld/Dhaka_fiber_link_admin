import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_dish_admin_panlel/model/total_count_model.dart';
import 'package:new_dish_admin_panlel/provider/head_provider.dart';
import 'package:new_dish_admin_panlel/provider/public_provider.dart';
import 'package:new_dish_admin_panlel/widgets/form_decoration.dart';
import 'package:new_dish_admin_panlel/widgets/total_count_table_body.dart';
import 'package:provider/provider.dart';

class Summary extends StatefulWidget {
  @override
  _SummaryState createState() => _SummaryState();
}

class _SummaryState extends State<Summary> {
  bool _isLoading=false;
  String? billMonth;
  DateTime? _searchDate;
  List<TotalCountModel> filteredCounts = [];
  List<TotalCountModel> countList = [];
  int _counter = 0;
  String? searchString;
  void _initializeDate(){
    setState(() {
      _searchDate = DateTime.now();
    });
  }
  Future<void> _pickSearchDate(BuildContext context)async{
    final DateTime picked = (await showDatePicker(
        context: context,
        initialDate: _searchDate!,
        firstDate:  DateTime(2010),
        lastDate: DateTime(2050)))!;
    if (picked != _searchDate)
      setState(() {
        _searchDate = picked;
      });
  }
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final PublicProvider publicProvider = Provider.of<PublicProvider>(context);
    final HeadProvider headProvider = Provider.of<HeadProvider>(context);
    if (_counter == 0) {
      setState(() {
        countList=headProvider.totalCountList;
        filteredCounts=countList;
        _counter++;
      });
      _initializeDate();
    }
    return Container(
      width: publicProvider.pageWidth(size),
      child: Column(
        children: [
          ///Search Header
          Container(
            height: 50,
            margin: EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: publicProvider.pageWidth(size),
                  child: Row(
                    children: [

                      ///Calender Button
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: size.height * .008),
                        child: OutlinedButton(
                          onPressed: ()=>_pickSearchDate(context),
                          child: Padding(
                              padding: EdgeInsets.symmetric(vertical: size.height*.011),
                              child: Icon(Icons.calendar_today_outlined,color: Color(0xff006F64))),
                        ),
                      ),

                      ///Text Field
                      Expanded(
                        child: InkWell(
                            onTap: ()=>_pickSearchDate(context),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: size.height * .01,
                                  vertical: size.height*.011),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.all(Radius.circular(5))
                              ),
                              child: Text('All Record of:-  ${_searchDate!.day}/${_searchDate!.month}/${_searchDate!.year}',
                                  style: TextStyle(fontSize: size.height*.02,
                                      color: Colors.grey.shade900,
                                      fontFamily: 'OpenSans')),
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(5))
                        ),
                      ),

                      ///Search Button
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: size.height * .008),
                        child: OutlinedButton(
                          onPressed: (){
                            setState(() {
                              filteredCounts = countList
                                  .where((u) => ('${u.id}'.toLowerCase()
                                  .contains('${_searchDate!.month}-${_searchDate!.year}'.toLowerCase())))
                                  .toList();
                            });
                          },
                          child: Padding(
                              padding: EdgeInsets.symmetric(vertical: size.height*.011),
                              child: Icon(Icons.search,color: Colors.grey)),
                        ),
                      ),

                      ///Clear Button
                      // Padding(
                      //   padding: EdgeInsets.symmetric(horizontal: size.height * .008),
                      //   child: OutlinedButton(
                      //     onPressed: (){},
                      //     child: Padding(
                      //         padding: EdgeInsets.symmetric(vertical: size.height*.011),
                      //         child: Icon(Icons.clear,color: Colors.redAccent)),
                      //   ),
                      // ),

                      ///Reload Button
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: size.height * .008),
                        child: OutlinedButton(
                          onPressed: (){
                            setState(() {
                              countList=headProvider.totalCountList;
                              filteredCounts=countList;
                            });
                          },
                          child: Padding(
                              padding: EdgeInsets.symmetric(vertical: size.height*.011),
                              child: Icon(Icons.refresh,color: Color(0xff006F64),)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(),

          ///Table Header
          Container(
            height: 40,//60,
            margin: EdgeInsets.only(top: 10),
            child: Column(
              children: [
                // Expanded(
                //   child: OutlinedButton(
                //     onPressed: (){
                //       setState(() {
                //         customerList=customerProvider.dueCustomerList;
                //         filteredCustomers=customerList;
                //       });
                //     },
                //     child: Container(
                //       width: size.width*.08,
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         children: [
                //           Icon(Icons.refresh,color: Color(0xff006F64),),
                //           Text('Reload',style: TextStyle(color: Color(0xff006F64),fontWeight: FontWeight.bold),),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
                // SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _tableHeaderBuilder(size, 'Month'),
                    _tableHeaderBuilder(size, 'Total Debit'),
                    _tableHeaderBuilder(size, 'Total Credit'),
                    _tableHeaderBuilder(size, 'Profit'),
                  ],
                ),
                Divider(height: 5.0,color: Colors.grey.shade900)
              ],
            ),
          ),

          ///Table Body
          _isLoading
              ?Padding(
            padding:  EdgeInsets.only(top: 100),
            child: Center(child: spinCircle()),
          ): Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: filteredCounts.length,
              itemBuilder: (context,index)=>TotalCountTableBody(
                month: filteredCounts[index].month,
                year: filteredCounts[index].year,
                debit: filteredCounts[index].debit,
                credit: filteredCounts[index].credit,
              )
            ),
          )
        ],
      ),
    );
  }



  Widget _tableHeaderBuilder(Size size,String tableHeader){
    return Expanded(
      child: Container(
        // width: size.width<1300
        //     ?size.width*.111
        //     :size.width*.0888,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          // border: Border.all(color: Colors.grey.shade900)
        ),
        child: Text(
          tableHeader,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.grey.shade900,
              fontSize: size.height*.022,
              fontWeight: FontWeight.bold,
              fontFamily: 'hindSiliguri'
          ),),
      ),
    );
  }
}
