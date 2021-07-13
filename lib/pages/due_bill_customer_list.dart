import 'package:flutter/material.dart';
import 'package:new_dish_admin_panlel/model/customer_model.dart';
import 'package:new_dish_admin_panlel/provider/customer_provider.dart';
import 'package:new_dish_admin_panlel/provider/public_provider.dart';
import 'package:new_dish_admin_panlel/widgets/form_decoration.dart';
import 'package:provider/provider.dart';

class DueBillCustomerList extends StatefulWidget {

  @override
  _DueBillCustomerListState createState() => _DueBillCustomerListState();
}

class _DueBillCustomerListState extends State<DueBillCustomerList> {
  bool _isLoading=false;
  var _controller = TextEditingController();
  List<CustomerModel> filteredCustomers = [];
  List<CustomerModel> customerList = [];
  int _counter = 0;
  String? searchString;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final PublicProvider publicProvider = Provider.of<PublicProvider>(context);
    final CustomerProvider customerProvider = Provider.of<CustomerProvider>(context);
    if (_counter == 0) {
      setState(() {
        customerList=customerProvider.dueCustomerList;
        filteredCustomers=customerList;
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
                              labelText: 'Search by Customer Name',
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
                              filteredCustomers = customerList
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
                              customerList=customerProvider.dueCustomerList;
                              filteredCustomers=customerList;
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
                    _tableHeaderBuilder(size, 'Id'),
                    _tableHeaderBuilder(size, 'Name'),
                    _tableHeaderBuilder(size, 'Phone'),
                    _tableHeaderBuilder(size, 'Address'),
                    _tableHeaderBuilder(size, 'Package'),
                    _tableHeaderBuilder(size, 'Bill Amount'),
                    _tableHeaderBuilder(size, 'Due Amount'),
                    _tableHeaderBuilder(size, 'Activity'),
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
              itemCount: filteredCustomers.length,
              itemBuilder: (context,index){
                int year=int.parse(filteredCustomers[index].lastEntryYear!);
                int month=int.parse(filteredCustomers[index].lastEntryMonth!);
                var a = DateTime.utc(year, month);
                var b = DateTime.now();

                var years = b.difference(a);
                var months=years.inDays ~/30;
                var dueAmount=filteredCustomers[index].billAmount!*months;

                return Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _tableBodyBuilder(size, '${filteredCustomers[index].id!}', publicProvider,customerProvider,months,dueAmount,filteredCustomers[index]),
                          _tableBodyBuilder(size, filteredCustomers[index].name!, publicProvider,customerProvider,months,dueAmount,filteredCustomers[index]),
                          _tableBodyBuilder(size, filteredCustomers[index].phone!, publicProvider,customerProvider,months,dueAmount,filteredCustomers[index]),
                          _tableBodyBuilder(size,filteredCustomers[index].address!,publicProvider,customerProvider,months,dueAmount,filteredCustomers[index]),
                          _tableBodyBuilder(size, filteredCustomers[index].package!,publicProvider,customerProvider,months,dueAmount,filteredCustomers[index]),
                          _tableBodyBuilder(size, filteredCustomers[index].billAmount!,publicProvider,customerProvider,months,dueAmount,filteredCustomers[index]),
                          _tableBodyBuilder(size, filteredCustomers[index].dueAmount==null?months==0?filteredCustomers[index].billAmount!:dueAmount:filteredCustomers[index].dueAmount!,publicProvider,customerProvider,months,dueAmount,filteredCustomers[index]),
                          _tableBodyBuilder(size, filteredCustomers[index].activity!,publicProvider,customerProvider,months,dueAmount,filteredCustomers[index]),
                          _tableBodyBuilder(size, '',publicProvider,customerProvider,months,dueAmount,filteredCustomers[index]),
                        ],
                      ),
                      SizedBox(height: 5.0),
                      Divider(height: 5.0,thickness: 0.5,color: Colors.grey)
                    ],
                  ),
                );
              },
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
  Widget _tableBodyBuilder(Size size,String tableData,PublicProvider publicProvider,CustomerProvider customerProvider,var months,var dueAmount,var dta){
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
            :ElevatedButton(
          style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Color(0xff006F64))),
          child: Text('Pay Bill',
              style: TextStyle(fontSize: size.height*.018,fontFamily: 'OpenSans',color: Colors.white)),
          onPressed: (){
            publicProvider.category= publicProvider.subCategory;
            publicProvider.subCategory='Pay Bill';
            setState(() {
              publicProvider.customerModel.id=dta.id;
              publicProvider.customerModel.name=dta.name;
              publicProvider.customerModel.phone=dta.phone;
              publicProvider.customerModel.address=dta.address;
              publicProvider.customerModel.package=dta.package;
              publicProvider.customerModel.dueAmount=dta.dueAmount==null?months==0?dta.billAmount:dueAmount:dta.dueAmount;
              publicProvider.customerModel.billAmount=dta.billAmount;
              publicProvider.customerModel.activity=dta.activity;
            });
            print(dta.installationFee);
          },
        ),
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
