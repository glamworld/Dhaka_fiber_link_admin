import 'package:flutter/material.dart';
import 'package:new_dish_admin_panlel/model/bill_man_model.dart';
import 'package:new_dish_admin_panlel/provider/bill_man_provider.dart';
import 'package:new_dish_admin_panlel/provider/public_provider.dart';
import 'package:new_dish_admin_panlel/widgets/bil_man_table_body.dart';
import 'package:new_dish_admin_panlel/widgets/form_decoration.dart';
import 'package:provider/provider.dart';

class BillManList extends StatefulWidget {

  @override
  _BillManListState createState() => _BillManListState();
}

class _BillManListState extends State<BillManList> {
  bool _isLoading=false;
  var _controller = TextEditingController();
  List<BillManModel> filteredBillMen = [];
  List<BillManModel> billManList = [];
  int _counter = 0;
  String? searchString;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final PublicProvider publicProvider = Provider.of<PublicProvider>(context);
    final BillManProvider billManProvider = Provider.of<BillManProvider>(context);
    if (_counter == 0) {
      setState(() {
        billManList=billManProvider.billManList;
        filteredBillMen=billManList;
        _counter++;
      });
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
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: TextFormField(
                            controller: _controller,
                            decoration: formDecoration(size).copyWith(
                              labelText: 'Search by BillMan Name',
                            ),
                            onChanged: (string){
                              setState(() {
                                searchString=string;
                              });
                            },
                          ),
                        ),
                      ),

                      ///Search Button
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: size.height * .008),
                        child: OutlinedButton(
                          onPressed: (){
                            setState(() {
                              filteredBillMen = billManList
                                  .where((u) => (u.name!.toLowerCase()
                                  .contains(searchString!.toLowerCase())))
                                  .toList();
                            });
                          },
                          child: Padding(
                              padding: EdgeInsets.symmetric(vertical: size.height*.011),
                              child: Icon(Icons.search,color: Colors.grey)),
                        ),
                      ),

                      ///Clear Button
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: size.height * .008),
                        child: OutlinedButton(
                          onPressed: (){
                            _controller.clear();
                          },
                          child: Padding(
                              padding: EdgeInsets.symmetric(vertical: size.height*.011),
                              child: Icon(Icons.clear,color: Colors.redAccent)),
                        ),
                      ),

                      ///Reload Button
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: size.height * .008),
                        child: OutlinedButton(
                          onPressed: (){
                            setState(() {
                              billManList=billManProvider.billManList;
                              filteredBillMen=billManList;
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
            height: 40,
            margin: EdgeInsets.only(top: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _tableHeaderBuilder(size, 'Name'),
                    _tableHeaderBuilder(size, 'Phone'),
                    _tableHeaderBuilder(size, 'Password'),
                    _tableHeaderBuilder(size, 'Address'),
                    _tableHeaderBuilder(size, ''),
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
              itemCount: filteredBillMen.length,
              itemBuilder: (context,index)=>BillManTableBody(
                id: filteredBillMen[index].id,
                name: filteredBillMen[index].name,
                phone: filteredBillMen[index].phone,
                password: filteredBillMen[index].password,
                address: filteredBillMen[index].address,
              ),
            ),
          )
          //     :Center(child: Column(
          //   children: [
          //     SizedBox(height: 100),
          //     Text('কোন ডেটা নেই!',
          //         style: TextStyle(fontFamily: 'hindSiliguri',
          //             fontSize: size.height*.026,color: Color(0xffF5B454))),
          //     TextButton(
          //         onPressed: ()async{
          //           setState(()=>_isLoading=true);
          //           await databaseProvider.getBodliKhanaDataList().then((value){
          //             setState(()=>_isLoading=false);
          //           });
          //         },
          //         child: Text('রিফ্রেশ করুন',style: TextStyle(fontFamily: 'hindSiliguri',fontSize: size.height*.021,),)
          //     )
          //   ],
          // ))
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
