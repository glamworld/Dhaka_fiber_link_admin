import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:new_dish_admin_panlel/model/billing_info_model.dart';
import 'package:new_dish_admin_panlel/model/total_bill_model.dart';
import 'package:new_dish_admin_panlel/widgets/form_decoration.dart';

import 'customer_provider.dart';
import 'head_provider.dart';

class BillingProvider extends ChangeNotifier{
  BillingInfoModel _billingInfoModel = BillingInfoModel();
  TotalBillModel _totalBillModel = TotalBillModel();
  List<BillingInfoModel> _approvedBillList=[];
  List<BillingInfoModel> _pendingBillList=[];
  List<TotalBillModel> _totalBillList=[];
  List<TotalBillModel> _currentBillList=[];

  get approvedBillList=> _approvedBillList;
  get pendingBillList=> _pendingBillList;
  get totalBillList=> _totalBillList;
  get currentBillList=> _currentBillList;
  BillingInfoModel get billingInfoModel=> _billingInfoModel;
  TotalBillModel get totalBillModel => _totalBillModel;

  set billingInfoModel(BillingInfoModel model) {
    model = BillingInfoModel();
    _billingInfoModel = model;
    notifyListeners();
  }
  set totalBillModel(TotalBillModel val){
    val= TotalBillModel();
    _totalBillModel = val;
    notifyListeners();
  }


  Future<bool> payBill(BillingInfoModel billingInfoModel,HeadProvider headProvider,CustomerProvider customerProvider) async {
    int timeStamp = DateTime.now().millisecondsSinceEpoch;
    int totalDebit= int.parse(headProvider.currentCountList[0].debit!);
    int totalBill= int.parse(_currentBillList[0].totalBillAmount!);
    int totalCredit= int.parse(headProvider.currentCountList[0].credit!);
    int currentBalance=int.parse(headProvider.totalCountList[0].currentBalance!);
    int cred=int.parse(billingInfoModel.amount!);
    int bill=totalBill+cred;
    num debit=totalDebit+0;
    num credit=totalCredit+cred;
    num pBalance=currentBalance+cred;
    String id= timeStamp.toString();
    final String monthYear = '${DateTime.now().month}-${DateTime.now().year}';
    try {
      FirebaseFirestore.instance.collection('UserBillingInfo').doc(id).set({
        'id': id,
        'name': billingInfoModel.name,
        'userPhone': billingInfoModel.userPhone,
        'userID': billingInfoModel.userID,
        'payBy': billingInfoModel.payBy,
        'deductKey': billingInfoModel.deductKey,
        'billingMonth': billingInfoModel.billingMonth,
        'billingYear': billingInfoModel.billingYear,
        'billingNumber': billingInfoModel.billingNumber,
        'transactionId': billingInfoModel.transactionId,
        'state':'approved',
        'amount': billingInfoModel.amount,
        'timeStamp': timeStamp,
        'payDate': billingInfoModel.payDate,
       })
        //   .then((value)async{
        // await FirebaseFirestore.instance.collection('totalCount').doc(monthYear).update({
        //   'id':monthYear,
        //   'debit': '$debit',
        //   'credit': '$credit',
        //   'currentBalance':'$pBalance'
        // })
          .then((value)async{
          await FirebaseFirestore.instance.collection('totalBill').doc(monthYear).update({
          'id':monthYear,
          'totalBillAmount': '$bill',
          }).then((value){
          getBillingInfo().then((value) {
            headProvider.getTotalCount();
            headProvider.getCurrentCount();
            getTotalBill();
            customerProvider.getDueCustomers();
            customerProvider.getPaidCustomers();
            showToast('Bill Paid');
          });
          });
        //});
      }, onError: (error) {
        showToast(error.toString());
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> getBillingInfo()async{
    try{
      await FirebaseFirestore.instance.collection('UserBillingInfo').where('state',isEqualTo: 'approved').orderBy('timeStamp',descending: true).get().then((snapshot){
        _approvedBillList.clear();
        snapshot.docChanges.forEach((element) {
          BillingInfoModel billingInfo = BillingInfoModel(
            id: element.doc['id'],
            name: element.doc['name'],
            userPhone: element.doc['userPhone'],
            userID: element.doc['userID'],
            payBy: element.doc['payBy'],
            deductKey: element.doc['deductKey'],
            billingMonth: element.doc['billingMonth'],
            billingYear: element.doc['billingYear'],
            billingNumber: element.doc['billingNumber'],
            transactionId: element.doc['transactionId'],
            amount: element.doc['amount'],
            state: element.doc['state'],
            //timeStamp: element.doc['timeStamp'],
            payDate: element.doc['payDate'],
          );
          _approvedBillList.add(billingInfo);
        });
      });
      notifyListeners();
      return Future.value(true);
    }catch(error){
      return Future.value(false);
    }
  }

  Future<bool> getPendingBillingInfo()async{
    try{
      await FirebaseFirestore.instance.collection('UserBillingInfo').where('state',isEqualTo: 'pending').orderBy('timeStamp',descending: true).get().then((snapshot){
        _pendingBillList.clear();
        snapshot.docChanges.forEach((element) {
          BillingInfoModel pendingBillingInfo = BillingInfoModel(
            id: element.doc['id'],
            name: element.doc['name'],
            userPhone: element.doc['userPhone'],
            userID: element.doc['userID'],
            payBy: element.doc['payBy'],
            deductKey: element.doc['deductKey'],
            billingMonth: element.doc['billingMonth'],
            billingYear: element.doc['billingYear'],
            billingNumber: element.doc['billingNumber'],
            transactionId: element.doc['transactionId'],
            amount: element.doc['amount'],
            state: element.doc['state'],
            //timeStamp: element.doc['timeStamp'],
            payDate: element.doc['payDate'],
          );
          _pendingBillList.add(pendingBillingInfo);
        });
      });
      notifyListeners();
      return Future.value(true);
    }catch(error){
      return Future.value(false);
    }
  }

Future<bool> approveUserBill(String id,BillingInfoModel billingInfoModel,HeadProvider headProvider,CustomerProvider customerProvider)async{
  int totalDebit= int.parse(headProvider.currentCountList[0].debit!);
  int totalCredit= int.parse(headProvider.currentCountList[0].credit!);
  int currentBalance=int.parse(headProvider.totalCountList[0].currentBalance!);
  int totalBill= int.parse(_currentBillList[0].totalBillAmount!);
  int cred=int.parse(billingInfoModel.amount!);
  int bill=totalBill+cred;
  num debit=totalDebit+0;
  num credit=totalCredit+cred;
  num pBalance=currentBalance+cred;
  final String monthYear = '${DateTime.now().month}-${DateTime.now().year}';
    try{
      await FirebaseFirestore.instance.collection('UserBillingInfo').doc(id).update({
        'state':'approved'
       })
        .then((value)async{
        await FirebaseFirestore.instance.collection('totalCount').doc(monthYear).update({
          'id':monthYear,
          'debit': '$debit',
          'credit': '$credit',
          'currentBalance':'$pBalance'
        }).then((value)async{
          await FirebaseFirestore.instance.collection('totalBill').doc(monthYear).update({
            'id':monthYear,
            'totalBillAmount': '$bill',
          })
            .then((value){
          getBillingInfo().then((value) {
            getPendingBillingInfo();
            headProvider.getCurrentCount();
            headProvider.getTotalCount();
            customerProvider.getDueCustomers();
            customerProvider.getPaidCustomers();
            showToast('Bill Approved');
          });
          });
        });
      }, onError: (error) {
        showToast(error.toString());
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> addTotalBill()async{
    String monthYear = '${DateTime.now().month}-${DateTime.now().year}';
    try{
      await FirebaseFirestore.instance.collection('totalBill').doc(monthYear.toString()).set({
        'id':monthYear,
        'totalBillAmount': '0',
        'month':'${DateTime.now().month}',
        'year':'${DateTime.now().year}',
      }).then((value){
        getTotalBill();
      }, onError: (error) {
        showToast(error.toString());
      });
      return Future.value(true);
    }catch(error){
      return Future.value(false);
    }
  }
  Future<bool> getTotalBill()async{
    try{
      await FirebaseFirestore.instance.collection('totalBill').orderBy('id', descending: true).get().then((snapshot){
        _totalBillList.clear();
        snapshot.docChanges.forEach((element) {
          TotalBillModel totalBillModel = TotalBillModel(
              id: element.doc['id'],
              totalBillAmount: element.doc['totalBillAmount'],
              month: element.doc['month'],
              year: element.doc['year'],
          );
          _totalBillList.add(totalBillModel);
        });
      });
      notifyListeners();
      return Future.value(true);
    }catch(error){
      return Future.value(false);
    }
  }

  Future<bool> getCurrentBill()async{
    String monthYear = '${DateTime.now().month}-${DateTime.now().year}';
    try{
      await FirebaseFirestore.instance.collection('totalBill').where('id',isEqualTo: monthYear.toString()).get().then((snapshot){
        _currentBillList.clear();
        snapshot.docChanges.forEach((element) {
          TotalBillModel totalBillModel = TotalBillModel(
            id: element.doc['id'],
            totalBillAmount: element.doc['totalBillAmount'],
            month: element.doc['month'],
            year: element.doc['year'],
          );
          _currentBillList.add(totalBillModel);
        });
      });
      notifyListeners();
      return Future.value(true);
    }catch(error){
      return Future.value(false);
    }
  }
}