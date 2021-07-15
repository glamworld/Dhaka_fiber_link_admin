import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_dish_admin_panlel/provider/bill_man_provider.dart';
import 'package:new_dish_admin_panlel/provider/billing_provider.dart';
import 'package:new_dish_admin_panlel/provider/customer_provider.dart';
import 'package:new_dish_admin_panlel/provider/head_provider.dart';
import 'package:new_dish_admin_panlel/provider/public_provider.dart';
import 'package:new_dish_admin_panlel/widgets/variables.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  int count=0;

  void _initialize()async{
    final HeadProvider headProvider = Provider.of<HeadProvider>(context);
    final BillingProvider billingProvider = Provider.of<BillingProvider>(context);
    final snapShot1 = await FirebaseFirestore.instance
        .collection('totalBill')
        .doc('${DateTime.now().month}-${DateTime.now().year}') // varuId in your case
        .get();
    final snapShot = await FirebaseFirestore.instance
        .collection('totalCount')
        .doc('${DateTime.now().month}-${DateTime.now().year}') // varuId in your case
        .get();
    if(!snapShot.exists){
      headProvider.addTotalCount();
    }
    if(!snapShot1.exists){
      billingProvider.addTotalBill();
    }
  }

  @override
  Widget build(BuildContext context){
    final Size size = MediaQuery.of(context).size;
    final PublicProvider publicProvider = Provider.of<PublicProvider>(context);
    final CustomerProvider customerProvider = Provider.of<CustomerProvider>(context);
    final BillManProvider billManProvider = Provider.of<BillManProvider>(context);
    final BillingProvider billingProvider = Provider.of<BillingProvider>(context);
    final HeadProvider headProvider = Provider.of<HeadProvider>(context);
    if(count==0){
      _initialize();
      customerProvider.getCustomers();
      customerProvider.getDueCustomers();
      customerProvider.getPaidCustomers();
      customerProvider.getUserProblem();
      billManProvider.getAllBillMan();
      headProvider.getCashBookDetails();
      headProvider.getBankBookDetails();
      headProvider.getHeadOfAccountBank();
      headProvider.getHeadOfAccountCash();
      headProvider.getHeadOfAccountBill();
      headProvider.getTotalCount();
      headProvider.getExpenses();
      billingProvider.getTotalBill();
      billingProvider.getCurrentBill();
      headProvider.getCurrentCount();
      billingProvider.getBillingInfo();
      billingProvider.getPendingBillingInfo();
      setState(() {
        count++;
      });
    }
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.blueGrey.shade50,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Container(
          height: 60,
          width: size.width,
          //color: Theme.of(context).primaryColor,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xff162B36),
                    Color(0xff006F64)
                  ]
              )
          ),
          padding: EdgeInsets.symmetric(
              horizontal: size.height * .02, vertical: size.height * .01),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              size.width < 1300
                  ? IconButton(
                      onPressed: () => _scaffoldKey.currentState!.openDrawer(),
                      icon: Icon(
                        Icons.menu,
                        color: Colors.grey.shade200,
                      ))
                  : InkWell(
                      onTap: () {
                        publicProvider.subCategory = 'Dashboard';
                        publicProvider.category = '';
                      },
                      child: Row(
                        children: [
                          Image.asset('assets/white_logo.png'),
                          SizedBox(width: size.height * .01),
                          Text('Dhaka Fiber Link LTD',
                              style: TextStyle(
                                  fontSize: size.height * .02,
                                  color: Colors.grey.shade200,
                                  fontFamily: 'OpenSans')),
                        ],
                      ),
                    ),
              Text(publicProvider.pageHeader(),
                  style: TextStyle(
                      fontSize: size.height * .025,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade200,
                      fontFamily: 'OpenSans')),
              Ink(
                child: InkWell(
                  onTap: () async {},
                  child: Row(
                    children: [
                      Text(
                        'Logout',
                        style: TextStyle(
                            fontSize: size.height * .02,
                            color: Colors.grey.shade200,
                            fontFamily: 'OpenSans'),
                      ),
                      SizedBox(width: size.height * .01),
                      Icon(
                        Icons.logout,
                        size: size.height * .025,
                        color: Colors.grey.shade200,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: NavigationDrawer(),
      body: _bodyUI(size, publicProvider),
    );
  }

  Widget _bodyUI(Size size, PublicProvider publicProvider) => Container(
        height: size.height,
        width: size.width,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [SideBar(), publicProvider.pageBody()],
        ),
      );
}

///Sidebar
class SideBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final PublicProvider publicProvider = Provider.of<PublicProvider>(context);
    return Container(
      width: size.width < 1300 ? 0.0 : size.width * .15,
      height: size.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xff162B36),
            Color(0xff006F64)
          ]
        )
      ),
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          SidebarContentBuilder(title: 'Dashboard'),
          SidebarContentBuilder(title: 'Add New Customer'),

          ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: Variables.sideBarMenuList().length,
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) => EntryItemTile(
                Variables.sideBarMenuList()[index],
                size,
                publicProvider,
                context),
          ),
          SidebarContentBuilder(title: 'Cash Book'),
          SidebarContentBuilder(title: 'Bank Book'),
          SidebarContentBuilder(title: 'Head'),
          SidebarContentBuilder(title: 'Summary'),
          SidebarContentBuilder(title: 'About Us'),
        ],
      ),
    );
  }
}

///Sidebar Builder
// ignore: must_be_immutable
class SidebarContentBuilder extends StatelessWidget {
  String title;
  SidebarContentBuilder({required this.title});
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final PublicProvider publicProvider = Provider.of<PublicProvider>(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: InkWell(
        onTap: () {
          publicProvider.subCategory = title;
          publicProvider.category = '';
          if (size.width < 1300) Navigator.pop(context);
        },
        child: Text(title,
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: size.height * .02,
                color: Colors.grey.shade300)),
      ),
    );
  }
}


///Drawer Sidebar
class NavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final PublicProvider publicProvider = Provider.of<PublicProvider>(context);
    return Container(
        margin: EdgeInsets.only(top: 60),
        child: Drawer(
          elevation: 0.0,
          child: Container(
            width: size.width < 1300 ? 0.0 : size.width * .15,
            height: size.height,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xff162B36),
                      Color(0xff006F64)
                    ]
                )
            ),
            child: ListView(
              scrollDirection: Axis.vertical,
              children: [
                SidebarContentBuilder(title: 'Dashboard'),
                SidebarContentBuilder(title: 'Add New Customer'),

                ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: Variables.sideBarMenuList().length,
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) => EntryItemTile(
                      Variables.sideBarMenuList()[index],
                      size,
                      publicProvider,
                      context),
                ),
                SidebarContentBuilder(title: 'Cash Book'),
                SidebarContentBuilder(title: 'Bank Book'),
                SidebarContentBuilder(title: 'Head'),
                SidebarContentBuilder(title: 'Summary'),
                SidebarContentBuilder(title: 'About Us'),
              ],
            ),
          ),
        ));
  }
}


///Create the widget for the row...
// ignore: must_be_immutable
class EntryItemTile extends StatelessWidget {
  final Entry entry;
  final Size size;
  PublicProvider publicProvider;
  BuildContext context;
  EntryItemTile(this.entry, this.size, this.publicProvider, this.context);
  String? _category;
  String? _subCategory;

  Widget _buildTiles(Entry root) {
    if (root.children.isEmpty) {
      return ListTile(
        onTap: () {
          _subCategory = root.title;
          publicProvider.category = _category!;
          publicProvider.subCategory = _subCategory!;
          if (size.width < 1300) Navigator.pop(context);
        },
        contentPadding: EdgeInsets.only(left: 30),
        dense: true,
        title: Text(root.title,
            style: TextStyle(color: Colors.grey.shade300,
                fontSize: size.height * .02,
                fontFamily: 'OpenSans')),
      );
    }
    return ExpansionTile(
      key: PageStorageKey<Entry>(root),
      title: Text(root.title,
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: size.height * .02,
              color: Colors.grey.shade300,fontFamily: 'OpenSans')),
      trailing: Icon(
        Icons.keyboard_arrow_down,
        color: Colors.grey.shade300,
      ),
      onExpansionChanged: (val) {
        _category = root.title;
      },
      children: root.children.map<Widget>(_buildTiles).toList(),
    );
  }
  @override
  Widget build(BuildContext context) {
    return _buildTiles(entry);
  }
}
