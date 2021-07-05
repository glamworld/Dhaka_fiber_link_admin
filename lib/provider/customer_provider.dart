import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:new_dish_admin_panlel/model/customer_model.dart';
import 'package:new_dish_admin_panlel/model/problem_model.dart';
import 'package:new_dish_admin_panlel/provider/public_provider.dart';
import '../widgets/form_decoration.dart';
import 'package:intl/intl.dart';

class CustomerProvider extends ChangeNotifier{
  CustomerModel _customerModel = CustomerModel();
  List<CustomerModel> _customerList= [];
  List<CustomerModel> _paidCustomerList= [];
  List<CustomerModel> _dueCustomerList= [];
  List<ProblemModel> _userProblemList = [];

  get customerList=> _customerList;
  get paidCustomerList=> _paidCustomerList;
  get dueCustomerList=> _dueCustomerList;
  get userProblemList=> _userProblemList;
  CustomerModel get customerModel=> _customerModel;

  set customerModel(CustomerModel model) {
    model = CustomerModel();
    _customerModel = model;
    notifyListeners();
  }

  Future<bool> addNewCustomer(CustomerModel customerModel,num id) async {
    String year = DateFormat("yyyy").format(
        DateTime.fromMillisecondsSinceEpoch(
            DateTime.now().millisecondsSinceEpoch));
    String month = DateFormat("MM").format(
        DateTime.fromMillisecondsSinceEpoch(
            DateTime.now().millisecondsSinceEpoch));
    try {
      FirebaseFirestore.instance.collection('Customers').doc('$id').set({
        'id': id,
        'name': customerModel.name,
        'address': customerModel.address,
        'phone': customerModel.phone,
        'billAmount': customerModel.billAmount,
        'billState': 'due',
        'dueAmount': null,
        'lastEntryYear': year,
        'lastEntryMonth': month,
        'monthYear': '$month/$year',
        'activity' : 'Active',
        'deductKey': customerModel.deductKey,
        'package': customerModel.package,
      }).then((value)async{
        await getCustomers().then((value) {
          getDueCustomers();
          showToast('Customer added');
        });
      }, onError: (error) {
        showToast(error.toString());
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> getCustomers()async{

    try{
      await FirebaseFirestore.instance.collection('Customers').get().then((snapshot) {
        _customerList.clear();
        snapshot.docChanges.forEach((element) {
          CustomerModel customerModel = CustomerModel(
            id: element.doc['id'],
            name: element.doc['name'],
            address: element.doc['address'],
            phone: element.doc['phone'],
            billAmount: element.doc['billAmount'],
            activity: element.doc['activity'],
            deductKey: element.doc['deductKey'],
            package: element.doc['package'],
            lastEntryMonth: element.doc['lastEntryMonth'],
            lastEntryYear: element.doc['lastEntryYear'],
            monthYear: element.doc['monthYear']
          );
          _customerList.add(customerModel);
        });
      });
      notifyListeners();
    }catch(error){
      print(error.toString());
    }
  }

  Future<void> updateCustomer(String id,PublicProvider publicProvider)async {
    FirebaseFirestore.instance.collection('Customers').doc(id).update({
      'name': publicProvider.customerModel.name,
      'address': publicProvider.customerModel.address,
      'phone': publicProvider.customerModel.phone,
      'billAmount': publicProvider.customerModel.billAmount,
      'activity': publicProvider.customerModel.activity,
      'deductKey': publicProvider.customerModel.deductKey,
      'package': publicProvider.customerModel.package,

    }).then((value)async{
      showToast('Customer Updated');
      getCustomers();
      notifyListeners();
    });
  }
  Future<void> deleteCustomer(num id)async{
    await FirebaseFirestore.instance.collection('Customers').doc('$id').delete().then((value) async{
      await getCustomers().then((value) {
        showToast('Customer deleted');
      });
    },onError: (error){
      //showSnackBar(scaffoldKey, error.toString());
    });
  }

  Future<void> getDueCustomers()async{
    final String monthYear = '${DateTime.now().month}/${DateTime.now().year}';
    try{
      await FirebaseFirestore.instance.collection('Customers').get().then((snapshot) {
        _dueCustomerList.clear();
        snapshot.docChanges.forEach((element) {
          if(monthYear != element.doc['monthYear'] || element.doc['billState']=='due'){
            CustomerModel customerModel = CustomerModel(
              id: element.doc['id'],
              name: element.doc['name'],
              address: element.doc['address'],
              phone: element.doc['phone'],
              billAmount: element.doc['billAmount'],
              billState: element.doc['billState'],
              dueAmount: element.doc['dueAmount'],
              lastEntryYear: element.doc['lastEntryYear'],
              lastEntryMonth: element.doc['lastEntryMonth'],
              activity: element.doc['activity'],
              deductKey: element.doc['deductKey'],
              package: element.doc['package'],
              monthYear: element.doc['monthYear']
            );
            _dueCustomerList.add(customerModel);
          }
        });
        print(_dueCustomerList.length);
      });
      notifyListeners();
    }catch(error){
      print(error.toString());
    }
  }

  Future<void> getPaidCustomers()async{
    final String monthYear = '${DateTime.now().month}/${DateTime.now().year}';
    try{
      await FirebaseFirestore.instance.collection('Customers').get().then((snapshot) {
        _paidCustomerList.clear();
        snapshot.docChanges.forEach((element) {
          if(monthYear == element.doc['monthYear'] && element.doc['billState']=='paid'){
            CustomerModel customerModel = CustomerModel(
              id: element.doc['id'],
              name: element.doc['name'],
              address: element.doc['address'],
              phone: element.doc['phone'],
              billAmount: element.doc['billAmount'],
              billState: element.doc['billState'],
              dueAmount: element.doc['dueAmount'],
              lastEntryMonth: element.doc['lastEntryMonth'],
              lastEntryYear: element.doc['lastEntryYear'],
              activity: element.doc['activity'],
              deductKey: element.doc['deductKey'],
              package: element.doc['package'],
              monthYear: element.doc['monthYear'],
            );
            _paidCustomerList.add(customerModel);
          }
        });
        print(_paidCustomerList.length);
      });
      notifyListeners();
    }catch(error){
      print(error.toString());
    }
  }

  Future<void> updateCustomerState(num id,PublicProvider publicProvider)async {
    FirebaseFirestore.instance.collection('Customers').doc('$id').update({
      'billState': publicProvider.customerModel.billState,
      'dueAmount': publicProvider.customerModel.dueAmount,
      'lastEntryYear':publicProvider.customerModel.lastEntryYear,
      'lastEntryMonth':publicProvider.customerModel.lastEntryMonth,
      'monthYear': '${publicProvider.customerModel.lastEntryMonth}/${publicProvider.customerModel.lastEntryYear}',

    }).then((value)async{
      //showToast('Customer Updated');
      getCustomers();
      notifyListeners();
    });
  }

  Future<bool> getUserProblem()async{
    try{
      await FirebaseFirestore.instance.collection('UserProblems').orderBy('timeStamp',descending: true).where('status',isEqualTo: 'pending').get().then((snapshot){
        _userProblemList.clear();
        snapshot.docChanges.forEach((element) {
          ProblemModel problemModel = ProblemModel(
              id: element.doc['id'],
              phone: element.doc['phone'],
              name: element.doc['name'],
              address: element.doc['address'],
              timeStamp: element.doc['timeStamp'],
              problem: element.doc['problem'],
              status: element.doc['status'],
              issueDate: element.doc['issueDate']
          );
          _userProblemList.add(problemModel);
        });
      });
      notifyListeners();
      return Future.value(true);
    }catch(error){
      return Future.value(false);
    }
  }

}