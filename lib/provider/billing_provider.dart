import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:new_dish_admin_panlel/model/billing_info_model.dart';
import 'package:new_dish_admin_panlel/widgets/form_decoration.dart';

import 'customer_provider.dart';
import 'head_provider.dart';

class BillingProvider extends ChangeNotifier{
  BillingInfoModel _billingInfoModel = BillingInfoModel();
  List<BillingInfoModel> _approvedBillList=[];
  //List<BillingInfoModel> _pendingBillList=[];

  get approvedBillList=> _approvedBillList;
  //get pendingBillList=> _pendingBillList;
  BillingInfoModel get billingInfoModel=> _billingInfoModel;

  set billingInfoModel(BillingInfoModel model) {
    model = BillingInfoModel();
    _billingInfoModel = model;
    notifyListeners();
  }


  Future<bool> payBill(BillingInfoModel billingInfoModel,HeadProvider headProvider,CustomerProvider customerProvider) async {
    int timeStamp = DateTime.now().millisecondsSinceEpoch;
    String id= timeStamp.toString();
    try {
      FirebaseFirestore.instance.collection('UserBillingInfo').doc(id).set({
        'id': id,
        'name': billingInfoModel.name,
        'userPhone': billingInfoModel.userPhone,
        'userID': billingInfoModel.userID,
        'payBy': billingInfoModel.payBy,
        'billingMonth': billingInfoModel.billingMonth,
        'billingYear': billingInfoModel.billingYear,
        'billingNumber': billingInfoModel.billingNumber,
        'transactionId': billingInfoModel.transactionId,
        'amount': billingInfoModel.amount,
        'timeStamp': timeStamp,
        'payDate': billingInfoModel.payDate,
      }).then((value)async{
        await FirebaseFirestore.instance.collection('HeadDetails').doc(timeStamp.toString()).set({
          'id':timeStamp.toString(),
          'title':'Bill Pay',
          'name':billingInfoModel.name,
          'details':'Client\'s monthly bill',
          'debit':billingInfoModel.amount,
          'credit': '0',
          'month': billingInfoModel.billingMonth,
          'year': billingInfoModel.billingYear,
        }).then((value){
          getBillingInfo().then((value) {
            headProvider.getAllHeadDetails();
            customerProvider.getDueCustomers();
            customerProvider.getPaidCustomers();
            showToast('Bill Paid');
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

  Future<bool> getBillingInfo()async{
    try{
      await FirebaseFirestore.instance.collection('UserBillingInfo').orderBy('timeStamp',descending: true).get().then((snapshot){
        _approvedBillList.clear();
        snapshot.docChanges.forEach((element) {
          BillingInfoModel billingInfo = BillingInfoModel(
            id: element.doc['id'],
            name: element.doc['name'],
            userPhone: element.doc['userPhone'],
            userID: element.doc['userID'],
            payBy: element.doc['payBy'],
            billingMonth: element.doc['billingMonth'],
            billingYear: element.doc['billingYear'],
            billingNumber: element.doc['billingNumber'],
            transactionId: element.doc['transactionId'],
            amount: element.doc['amount'],
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

// Future<bool> approveUserBill(String id, String userID)async{
//     try{
//       await FirebaseFirestore.instance.collection('UserBillingInfo').doc(id).update({
//         'state':'approved'
//       }).then((value)async{
//         await FirebaseFirestore.instance.collection('Users').doc(userID).update({
//           'billingState': 'approved',
//         });
//         await getPendingBillingInfo();
//         notifyListeners();
//       });
//       return Future.value(true);
//     }catch(error){
//       return Future.value(false);
//     }
// }
}