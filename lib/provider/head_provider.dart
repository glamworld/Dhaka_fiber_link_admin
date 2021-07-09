import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:new_dish_admin_panlel/model/about_model.dart';
import 'package:new_dish_admin_panlel/model/head_model.dart';
import 'package:new_dish_admin_panlel/model/head_of_account_model.dart';
import 'package:new_dish_admin_panlel/model/total_count_model.dart';
import 'package:new_dish_admin_panlel/widgets/form_decoration.dart';

class HeadProvider extends ChangeNotifier{
  HeadModel _headModel = HeadModel();
  AboutModel _aboutModel = AboutModel();
  TotalCountModel _totalCountModel = TotalCountModel();
  HeadOfAccountModel _headOfAccountModel = HeadOfAccountModel();
  List<HeadModel> _cashBookList=[];
  List<HeadModel> _bankBookList=[];
  List<HeadOfAccountModel> _headOfAccountBankList=[];
  List<HeadOfAccountModel> _headOfAccountCashList=[];
  List<TotalCountModel> _totalCountList=[];
  List<TotalCountModel> _currentCountList=[];

  HeadModel get headModel=> _headModel;
  AboutModel get aboutModel => _aboutModel;
  HeadOfAccountModel get headOfAccountModel => _headOfAccountModel;
  TotalCountModel get totalCountModel => _totalCountModel;
  get cashBookList=> _cashBookList;
  get bankBookList=> _bankBookList;
  get headOfAccountBankList=> _headOfAccountBankList;
  get headOfAccountCashList=> _headOfAccountCashList;
  get totalCountList=> _totalCountList;
  get currentCountList=> _currentCountList;

  set headModel(HeadModel val){
    val= HeadModel();
    _headModel = val;
    notifyListeners();
  }
  set aboutModel(AboutModel val){
    val= AboutModel();
    _aboutModel = val;
    notifyListeners();
  }
  set headOfAccountModel(HeadOfAccountModel val){
    val= HeadOfAccountModel();
    _headOfAccountModel = val;
    notifyListeners();
  }
  set totalCountModel(TotalCountModel val){
    val= TotalCountModel();
    _totalCountModel = val;
    notifyListeners();
  }

  Future<bool> addCashBookDetails(HeadModel headModel)async{
    int totalDebit= int.parse(currentCountList[0].debit!);
    int totalCredit= int.parse(currentCountList[0].credit!);
    final String monthYear = '${DateTime.now().month}-${DateTime.now().year}';
    String year = DateFormat("yyyy").format(
        DateTime.fromMillisecondsSinceEpoch(
            DateTime.now().millisecondsSinceEpoch));
    String month = DateFormat("MM").format(
        DateTime.fromMillisecondsSinceEpoch(
            DateTime.now().millisecondsSinceEpoch));

    int deb=int.parse(headModel.debit!);
    int cred=int.parse(headModel.credit!);
    num debit=totalDebit+deb;
    num credit=totalCredit+cred;
    try{
      int timeStamp = DateTime.now().millisecondsSinceEpoch;
      await FirebaseFirestore.instance.collection('CashBookDetails').doc(timeStamp.toString()).set({
        'id':timeStamp.toString(),
        'headOfAccount':headModel.headOfAccount,
        'name':headModel.name,
        'details':headModel.details,
        'debit':headModel.debit,
        'credit': headModel.credit,
        'month': month,
        'year': year,
      }).then((value)async{
        await FirebaseFirestore.instance.collection('totalCount').doc(monthYear).update({
        'id':monthYear,
        'debit': '$debit',
        'credit': '$credit',
        }).then((value){
          getCashBookDetails().then((value) {
            getCurrentCount();
            showToast('Details Saved');
          });
        });

      }, onError: (error) {
        showToast(error.toString());
      });
      return Future.value(true);
    }catch(error){
      return Future.value(false);
    }
  }

  Future<bool> getCashBookDetails()async{
    try{
      await FirebaseFirestore.instance.collection('CashBookDetails').get().then((snapshot){
        _cashBookList.clear();
        snapshot.docChanges.forEach((element) {
          HeadModel headModel = HeadModel(
            id: element.doc['id'],
            headOfAccount: element.doc['headOfAccount'],
            name: element.doc['name'],
            details: element.doc['details'],
            debit: element.doc['debit'],
            credit: element.doc['credit'],
            month: element.doc['month'],
            year: element.doc['year']
          );
          _cashBookList.add(headModel);
        });
      });
      notifyListeners();
      return Future.value(true);
    }catch(error){
      return Future.value(false);
    }
  }
  Future<bool> addBankBookDetails(HeadModel headModel)async{
    int totalDebit= int.parse(currentCountList[0].debit!);
    int totalCredit= int.parse(currentCountList[0].credit!);
    int deb=int.parse(headModel.debit!);
    int cred=int.parse(headModel.credit!);
    num debit=totalDebit+deb;
    num credit=totalCredit+cred;
    final String monthYear = '${DateTime.now().month}-${DateTime.now().year}';
    String year = DateFormat("yyyy").format(
        DateTime.fromMillisecondsSinceEpoch(
            DateTime.now().millisecondsSinceEpoch));
    String month = DateFormat("MM").format(
        DateTime.fromMillisecondsSinceEpoch(
            DateTime.now().millisecondsSinceEpoch));
    try{
      int timeStamp = DateTime.now().millisecondsSinceEpoch;
      await FirebaseFirestore.instance.collection('BankBookDetails').doc(timeStamp.toString()).set({
        'id':timeStamp.toString(),
        'headOfAccount':headModel.headOfAccount,
        'name':headModel.name,
        'details':headModel.details,
        'debit':headModel.debit,
        'credit': headModel.credit,
        'month': month,
        'year': year,
      }).then((value)async{
        await FirebaseFirestore.instance.collection('totalCount').doc(monthYear).update({
          'id':monthYear,
          'debit': '$debit',
          'credit': '$credit',
        }).then((value){
          getCashBookDetails().then((value) {
            getCurrentCount();
            showToast('Details Saved');
          });
        });

      }, onError: (error) {
        showToast(error.toString());
      });
      return Future.value(true);
    }catch(error){
      return Future.value(false);
    }
  }
  Future<bool> getBankBookDetails()async{
    try{
      await FirebaseFirestore.instance.collection('BankBookDetails').get().then((snapshot){
        _bankBookList.clear();
        snapshot.docChanges.forEach((element) {
          HeadModel headModel = HeadModel(
              id: element.doc['id'],
              headOfAccount: element.doc['headOfAccount'],
              name: element.doc['name'],
              details: element.doc['details'],
              debit: element.doc['debit'],
              credit: element.doc['credit'],
              month: element.doc['month'],
              year: element.doc['year']
          );
          _bankBookList.add(headModel);
        });
      });
      notifyListeners();
      return Future.value(true);
    }catch(error){
      return Future.value(false);
    }
  }

  Future<bool> addHeadOfAccountBank(HeadOfAccountModel headOfAccountModel)async{
    try{
      int timeStamp = DateTime.now().millisecondsSinceEpoch;
      await FirebaseFirestore.instance.collection('HeadOfAccount').doc(timeStamp.toString()).set({
        'id':timeStamp.toString(),
        'name':headOfAccountModel.name,
        'type': 'Bank'
      }).then((value){
        getHeadOfAccountBank().then((value) {
          showToast('Saved');
        });
      }, onError: (error) {
        showToast(error.toString());
      });
      return Future.value(true);
    }catch(error){
      return Future.value(false);
    }
  }

  Future<bool> getHeadOfAccountBank()async{
    try{
      await FirebaseFirestore.instance.collection('HeadOfAccount').where('type',isEqualTo: 'Bank').get().then((snapshot){
        _headOfAccountBankList.clear();
        snapshot.docChanges.forEach((element) {
          HeadOfAccountModel headModel = HeadOfAccountModel(
              id: element.doc['id'],
              name: element.doc['name'],
          );
          _headOfAccountBankList.add(headModel);
        });
      });
      notifyListeners();
      return Future.value(true);
    }catch(error){
      return Future.value(false);
    }
  }

  Future<bool> addHeadOfAccountCash(HeadOfAccountModel headOfAccountModel)async{
    try{
      int timeStamp = DateTime.now().millisecondsSinceEpoch;
      await FirebaseFirestore.instance.collection('HeadOfAccount').doc(timeStamp.toString()).set({
        'id':timeStamp.toString(),
        'name':headOfAccountModel.name,
        'type': 'Cash'
      }).then((value){
        getHeadOfAccountCash().then((value) {
          showToast('Saved');
        });
      }, onError: (error) {
        showToast(error.toString());
      });
      return Future.value(true);
    }catch(error){
      return Future.value(false);
    }
  }

  Future<bool> getHeadOfAccountCash()async{
    try{
      await FirebaseFirestore.instance.collection('HeadOfAccount').where('type',isEqualTo: 'Cash').get().then((snapshot){
        _headOfAccountCashList.clear();
        snapshot.docChanges.forEach((element) {
          HeadOfAccountModel headModel = HeadOfAccountModel(
            id: element.doc['id'],
            name: element.doc['name'],
          );
          _headOfAccountCashList.add(headModel);
        });
      });
      notifyListeners();
      return Future.value(true);
    }catch(error){
      return Future.value(false);
    }
  }

  Future<bool> writeAbout(AboutModel aboutModel)async{
    try{
      await FirebaseFirestore.instance.collection('About').doc('1234').set({
        'id':'1234',
        'description': aboutModel.description
      }).then((value){
        showToast('About Details Saved');
      }, onError: (error) {
        showToast(error.toString());
      });
      return Future.value(true);
    }catch(error){
      return Future.value(false);
    }
  }
  Future<bool> addTotalCount()async{
    String monthYear = '${DateTime.now().month}-${DateTime.now().year}';
    try{
      await FirebaseFirestore.instance.collection('totalCount').doc(monthYear.toString()).set({
        'id':monthYear,
        'debit': '0',
        'credit': '0',
        'month':'${DateTime.now().month}',
        'year':'${DateTime.now().year}'
      }).then((value){
        getTotalCount();
      }, onError: (error) {
        showToast(error.toString());
      });
      return Future.value(true);
    }catch(error){
      return Future.value(false);
    }
  }

  Future<bool> getTotalCount()async{
    try{
      await FirebaseFirestore.instance.collection('totalCount').get().then((snapshot){
        _totalCountList.clear();
        snapshot.docChanges.forEach((element) {
          TotalCountModel totalCountModel = TotalCountModel(
            id: element.doc['id'],
            debit: element.doc['debit'],
            credit: element.doc['credit'],
            month: element.doc['month'],
            year: element.doc['year']
          );
          _totalCountList.add(totalCountModel);
        });
      });
      notifyListeners();
      return Future.value(true);
    }catch(error){
      return Future.value(false);
    }
  }
  Future<bool> getCurrentCount()async{
    String monthYear = '${DateTime.now().month}-${DateTime.now().year}';
    try{
      await FirebaseFirestore.instance.collection('totalCount').where('id',isEqualTo: monthYear.toString()).get().then((snapshot){
        _currentCountList.clear();
        snapshot.docChanges.forEach((element) {
          TotalCountModel totalCountModel = TotalCountModel(
            id: element.doc['id'],
            debit: element.doc['debit'],
            credit: element.doc['credit'],
            month: element.doc['month'],
            year: element.doc['year']
          );
          _currentCountList.add(totalCountModel);
        });
      });
      notifyListeners();
      return Future.value(true);
    }catch(error){
      return Future.value(false);
    }
  }




// Future<void> deleteHead(String id)async{
  //   await FirebaseFirestore.instance.collection('HeadDetails').doc(id).delete().then((value) async{
  //     await getAllHeadDetails().then((value) {
  //       showToast('Record deleted');
  //     });
  //   },onError: (error){
  //     showToast(error.toString());
  //   });
  // }
  //
  // Future<void> updateHead(String id,PublicProvider publicProvider)async {
  //   FirebaseFirestore.instance.collection('HeadDetails').doc(id).update({
  //     'title':publicProvider.headModel.title,
  //     'name':publicProvider.headModel.name,
  //     'details':publicProvider.headModel.details,
  //     'debit':publicProvider.headModel.debit,
  //     'credit': publicProvider.headModel.credit,
  //
  //   }).then((value)async{
  //     showToast('Record Updated');
  //     getAllHeadDetails();
  //     notifyListeners();
  //   });
  // }

}