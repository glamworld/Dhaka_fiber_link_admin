import 'package:flutter/material.dart';
import 'package:new_dish_admin_panlel/model/head_model.dart';
import 'package:new_dish_admin_panlel/provider/head_provider.dart';
import 'package:new_dish_admin_panlel/provider/public_provider.dart';
import 'package:new_dish_admin_panlel/widgets/button_widget.dart';
import 'package:new_dish_admin_panlel/widgets/form_decoration.dart';
import 'package:new_dish_admin_panlel/widgets/head_account_table_body.dart';
import 'package:provider/provider.dart';

class HeadOfAccount extends StatefulWidget {

  @override
  _HeadOfAccountState createState() => _HeadOfAccountState();
}

class _HeadOfAccountState extends State<HeadOfAccount> with SingleTickerProviderStateMixin{
  TabController? _tabController;
  DateTime? _date;
  DateTime? _searchDate;
  List<HeadModel> filteredHeadDetails = [];
  List<HeadModel> headList = [];
  int _counter = 0;
  String? searchString;
  // TextEditingController _name = TextEditingController(text: '');
  // TextEditingController _debit = TextEditingController(text: '');
  // TextEditingController _credit = TextEditingController(text: '');
  // TextEditingController _details = TextEditingController(text: '');
  bool _isLoading=false;
  void _initializeData(HeadProvider auth) {
    auth.headModel.name = '';
    auth.headModel.title = '';
    auth.headModel.details = '';
    auth.headModel.debit = '';
    auth.headModel.credit = '';
    setState(() {
      _date = DateTime.now();
      _searchDate = DateTime.now();
    });
  }
  Future<void> _pickDate(BuildContext context)async{
    final DateTime picked = (await showDatePicker(
        context: context,
        initialDate: _date!,
        firstDate:  DateTime(2010),
        lastDate: DateTime(2050)))!;
    if (picked != _date)
      setState(() {
        _date = picked;
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
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final PublicProvider publicProvider = Provider.of<PublicProvider>(context);
    final HeadProvider auth = Provider.of<HeadProvider>(context);
    if (auth.headModel.name == null ||
        auth.headModel.details == null) {
      _initializeData(auth);
    }
    if (_counter == 0) {
      setState(() {
        headList=auth.headList;
        filteredHeadDetails=headList;
        _counter++;
      });
    }
    return Container(
      width: publicProvider.pageWidth(size),
      child: Column(
        children: [
          Material(
            color: Color(0xff006F64),
            child: TabBar(
                controller: _tabController,
                indicatorColor: Colors.lightGreenAccent,
                indicatorWeight: 5.0,
                tabs: [
                  Tab(child: Text(
                      'All Data',
                      style: TextStyle(fontSize: size.height*.02,
                          color: Colors.white,
                          fontFamily: 'OpenSans'))
                  ),
                  Tab(child: Text(
                      'Entry Data',
                      style: TextStyle(fontSize: size.height*.02,color: Colors.white,
                          fontFamily: 'OpenSans'))
                  )
                ]
            ),
          ),
          Expanded(
            child: TabBarView(
                controller: _tabController,
                children: [
                  _allData(size, publicProvider,auth),
                  _entryData(size, publicProvider,auth),
                ]
            ),
          ),
        ],
      ),
    );
  }

  Widget _allData(Size size, PublicProvider publicProvider,HeadProvider headProvider)=>Container(
    child: Center(
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
                              filteredHeadDetails = headList
                                  .where((u) => ('${u.month}/${u.year}'.toLowerCase()
                                  .contains('${_searchDate!.month}/${_searchDate!.year}'.toLowerCase())))
                                  .toList();
                            });
                          },
                          child: Padding(
                              padding: EdgeInsets.symmetric(vertical: size.height*.011),
                              child: Icon(Icons.search,color: Colors.grey)),
                        ),
                      ),
                      ///Clear Button
                      //   Padding(
                      //     padding: EdgeInsets.symmetric(horizontal: size.height * .008),
                      //     child: OutlinedButton(
                      //       onPressed: (){
                      //
                      //       },
                      //       child: Padding(
                      //           padding: EdgeInsets.symmetric(vertical: size.height*.011),
                      //           child: Icon(Icons.clear,color: Colors.redAccent)),
                      //     ),
                      //   ),
                        ///Reload Button
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: size.height * .008),
                          child: OutlinedButton(
                            onPressed: (){
                              setState(() {
                                headList=headProvider.headList;
                                filteredHeadDetails=headList;
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
                    _tableHeaderBuilder(size, 'Month'),
                    _tableHeaderBuilder(size, 'Title'),
                    _tableHeaderBuilder(size, 'Name'),
                    _tableHeaderBuilder(size, 'Details'),
                    _tableHeaderBuilder(size, 'Debit'),
                    _tableHeaderBuilder(size, 'Credit'),
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
              itemCount: filteredHeadDetails.length,
              itemBuilder: (context,index)=>HeadOfAccountTableBody(
                id: filteredHeadDetails[index].id,
                title: filteredHeadDetails[index].title,
                name: filteredHeadDetails[index].name,
                details: filteredHeadDetails[index].details,
                debit: filteredHeadDetails[index].debit,
                credit: filteredHeadDetails[index].credit,
                month: filteredHeadDetails[index].month,
                year: filteredHeadDetails[index].year,
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
    ),
  );

  Widget _entryData(Size size, PublicProvider publicProvider,HeadProvider headProvider)=>Container(
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
                child: Text('Add Transactions Information',
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
                  Expanded(child: _textBuilder(size, 'Title',headProvider)),
                  SizedBox(width: size.height*.04),
                  Expanded(
                    child: Container(
                      width: size.width * 5,
                      child: InkWell(
                        onTap: () {
                          _pickDate(context);
                        },
                        child: Container(
                          height: 40,
                          width: size.width * .15,
                          padding: EdgeInsets.symmetric(
                              horizontal: size.height * .01,
                              vertical: size.height * .011),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius:
                              BorderRadius.all(Radius.circular(5))),
                          child: Text('${_date!.year}-${_date!.month}',
                              style: TextStyle(
                                  fontSize: size.height * .02,
                                  color: Colors.grey.shade900,
                                  fontFamily: 'OpenSans')),
                        ),
                        //borderRadius: BorderRadius.all(Radius.circular(5))
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height*.04),
              Row(
                children: [
                  Expanded(child: _textBuilder(size, 'Name',headProvider)),
                  SizedBox(width: size.height*.04),
                  Expanded(child: _textBuilder(size, 'Details',headProvider)),
                ],
              ),
              SizedBox(height: size.height*.04),
              Row(
                children: [
                  Expanded(child: _textBuilder(size, 'Debit',headProvider)),
                  SizedBox(width: size.height*.04),
                  Expanded(child: _textBuilder(size, 'Credit',headProvider)),
                ],
              ),
              SizedBox(height: size.height*.04),

              SizedBox(height: size.height*.08),

              _isLoading?spinCircle():GradientButton(
                  child: Text('Save'),
                  onPressed: (){
                    _checkValidity(headProvider);
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

  Future<void> _checkValidity(HeadProvider auth) async{
    if(auth.headModel.name!.isNotEmpty && auth.headModel.title!.isNotEmpty && auth.headModel.details!.isNotEmpty &&
        auth.headModel.credit!.isNotEmpty && auth.headModel.debit!.isNotEmpty){
      setState(() {
        _isLoading=true;
      });
      setState(() {
        auth.headModel.month = '${_date!.month}';
        auth.headModel.year = '${_date!.year}';
      });
      Future.delayed(Duration(seconds: 2), ()async {
        bool result = await auth.addHeadDetails(auth.headModel);
        if(result){
          setState(() {
            _isLoading=false;
          });
        }
      });

    }else showToast('Complete all the required fields');
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

  Widget _textBuilder(Size size, String hint,HeadProvider headProvider){
    return TextField(
      // controller: hint=='Name'
      //     ?_name
      //     : hint=='Details'
      //     ?_details
      //     : hint=='Debit'
      //     ?_debit
      //     :_credit,
      decoration: formDecoration(size).copyWith(
        labelText: hint,
        hintStyle: TextStyle(fontSize: 14),
        fillColor: Color(0xffF4F7F5),
      ),
      onChanged: (val){
        setState(() {
          hint=='Title'? headProvider.headModel.title=val
          :hint=='Name'? headProvider.headModel.name=val
              :hint=='Details'? headProvider.headModel.details=val
              :hint=='Debit'?headProvider.headModel.debit=val
              :headProvider.headModel.credit=val;
        });
      },
    );
  }
}
