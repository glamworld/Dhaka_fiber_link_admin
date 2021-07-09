import 'package:flutter/material.dart';
import 'package:new_dish_admin_panlel/model/head_model.dart';
import 'package:new_dish_admin_panlel/model/head_of_account_model.dart';
import 'package:new_dish_admin_panlel/provider/head_provider.dart';
import 'package:new_dish_admin_panlel/provider/public_provider.dart';
import 'package:new_dish_admin_panlel/widgets/bank_book_table_body.dart';
import 'package:new_dish_admin_panlel/widgets/button_widget.dart';
import 'package:new_dish_admin_panlel/widgets/form_decoration.dart';
import 'package:provider/provider.dart';

class BankBookPage extends StatefulWidget {

  @override
  _BankBookPageState createState() => _BankBookPageState();
}

class _BankBookPageState extends State<BankBookPage> with SingleTickerProviderStateMixin{
  TabController? _tabController;
  bool _isLoading=false;
  List<HeadModel> filteredHeads = [];
  List<HeadModel> headList = [];
  //DateTime? _date;
  DateTime? _searchDate;
  int _counter = 0;
  String? searchString;
  String? _headOfAccount;
  List<dynamic> headAccounts = [];
  final _addKey = GlobalKey<FormState>();
  TextEditingController _name = TextEditingController(text: '');
  TextEditingController _debit = TextEditingController(text: '');
  TextEditingController _credit = TextEditingController(text: '');
  TextEditingController _details = TextEditingController(text: '');
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
  void _initializeData(HeadProvider auth){
    auth.headModel.name='';
    auth.headModel.details='';
    auth.headModel.debit='';
    auth.headModel.credit='';
  }

  @override
  void initState() {
    super.initState();
    _initializeDate();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final PublicProvider publicProvider = Provider.of<PublicProvider>(context);
    final HeadProvider headProvider = Provider.of<HeadProvider>(context);
    if (_counter == 0) {
      setState(() {
        headList=headProvider.bankBookList;
        filteredHeads=headList;
        _counter++;
      });
      _initializeData(headProvider);
    }
    setState(() {
      headAccounts=headProvider.headOfAccountBankList;
    });
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
                  _allData(size, publicProvider,headProvider),
                  _entryData(size, publicProvider,headProvider),
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
                              filteredHeads = headList
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
                              headList=headProvider.bankBookList;
                              filteredHeads=headList;
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
                    _tableHeaderBuilder(size, 'Head of Account'),
                    _tableHeaderBuilder(size, 'Account Name'),
                    _tableHeaderBuilder(size, 'Details'),
                    _tableHeaderBuilder(size, 'Debit'),
                    _tableHeaderBuilder(size, 'Credit'),
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
              itemCount: filteredHeads.length,
              itemBuilder: (context,index)=>BankBookTableBody(
                headOfAccount: filteredHeads[index].headOfAccount,
                name: filteredHeads[index].name,
                details: filteredHeads[index].details,
                debit: filteredHeads[index].debit,
                credit: filteredHeads[index].credit,
                month: filteredHeads[index].month,
                year: filteredHeads[index].year,
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

  Widget _entryData(Size size, PublicProvider publicProvider,HeadProvider headProvider){
    return Container(
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
                  child: Text('Add Bank Book Information',
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
                    Container(
                      width: size.width*.28,
                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: size.height*.01),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueGrey,width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(5))
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          isDense: true,
                          isExpanded: true,
                          value:_headOfAccount,
                          hint: Text('Select Head of Account',style: TextStyle(
                            color: Colors.grey,
                            fontFamily: 'OpenSans',
                            fontSize: size.height*.022,)),
                          items:headAccounts.map((category){
                            return DropdownMenuItem(
                              child: Text(category.name, style: TextStyle(
                                  color: Colors.grey[900],
                                  fontSize: size.height * .022,fontFamily: 'OpenSans'
                              )),
                              value: category.name.toString(),
                            );
                          }).toList(),
                          onChanged: (newVal){
                            setState(() {
                              _headOfAccount = newVal as String;
                              headProvider.headModel.headOfAccount=_headOfAccount;
                            });
                          },
                          dropdownColor: Colors.white,
                        ),
                      ),
                    ),
                    IconButton(icon: Icon(Icons.add_circle),onPressed: (){
                      _showDialog(headProvider, publicProvider);
                    },),
                    SizedBox(width: size.height*.04),
                    Expanded(child: _textBuilder(size, 'Name',headProvider)),
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
                _textBuilder(size, 'Details',headProvider),

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
  }
  Future<void> _checkValidity(HeadProvider auth) async{
    if(auth.headModel.name!.isNotEmpty && auth.headModel.details!.isNotEmpty && auth.headModel.debit!.isNotEmpty && auth.headModel.credit!.isNotEmpty &&
        auth.headModel.headOfAccount!=null ){
      setState(() {
        _isLoading=true;
      });

      Future.delayed(Duration(seconds: 2), ()async {
        bool result = await auth.addBankBookDetails(auth.headModel);
        if(result){
          setState(() {
            _isLoading=false;
          });
        }
      });

    }else showToast('Complete all the required fields');
  }


  _showDialog(HeadProvider headProvider,PublicProvider publicProvider) {
    String? name;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            scrollable: true,
            contentPadding: EdgeInsets.all(20),
            title: Text(
              "Add Head of Account",
              textAlign: TextAlign.center,
            ),
            content: Container(
              child: Form(
                key: _addKey,
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    TextFormField(
                      maxLines: 2,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(hintText: 'Write head of account'),
                      onSaved: (val) {
                        name = val!;
                      },
                      validator: (val) =>
                      val!.isEmpty ? 'please write head of account' : null,
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RaisedButton(
                          color: Colors.redAccent,
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        RaisedButton(
                          color: Theme.of(context).primaryColor,
                          onPressed: () {
                            Navigator.of(context).pop();
                            showToast('Please wait..');
                            if (_addKey.currentState!.validate()) {
                              _addKey.currentState!.save();
                              HeadOfAccountModel ap = HeadOfAccountModel();
                              setState(() {
                                ap.name = name;
                                headProvider.addHeadOfAccountBank(ap);
                              });
                              //Navigator.of(context).pop();
                            }
                          },
                          child: Text(
                            "Add",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
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
      controller: hint=='Name'
          ?_name
          : hint=='Debit'
          ?_debit
          :hint=='Credit'
          ?_credit
          :hint=='Details'
          ?_details:null,
      maxLines: hint=='Details'? 5:1,
      decoration: formDecoration(size).copyWith(
          labelText: hint
      ),
      onChanged: (val){
        setState(() {
          hint=='Name'? headProvider.headModel.name=val
              :hint=='Details'? headProvider.headModel.details=val
              :hint=='Debit'?headProvider.headModel.debit=val
              :headProvider.headModel.credit=val;
        });
      },
    );
  }
}
