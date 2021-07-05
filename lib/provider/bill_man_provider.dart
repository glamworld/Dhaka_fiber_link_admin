import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:new_dish_admin_panlel/model/bill_man_model.dart';
import 'package:new_dish_admin_panlel/provider/public_provider.dart';
import 'package:new_dish_admin_panlel/widgets/form_decoration.dart';

class BillManProvider extends ChangeNotifier{
  BillManModel _billManModel = BillManModel();
  List<BillManModel> _billManList=[];

  BillManModel get billManModel=> _billManModel;
  get billManList=> _billManList;

  set billManModel(BillManModel val){
    val= BillManModel();
    _billManModel = val;
    notifyListeners();
  }

  Future<bool> addNewBillMan(BillManModel billManModel)async{
    try{
      int timeStamp = DateTime.now().millisecondsSinceEpoch;
      await FirebaseFirestore.instance.collection('BillMan').doc('+88${billManModel.phone}').set({
        'id':'+88${billManModel.phone}',
        'phone':billManModel.phone,
        'name':billManModel.name,
        'password':billManModel.password,
        'address':billManModel.address,
        'timeStamp': timeStamp.toString(),
      }).then((value){
        getAllBillMan().then((value) {
          showToast('BillMan added');
        });
      }, onError: (error) {
        showToast(error.toString());
      });
      return Future.value(true);
    }catch(error){
      return Future.value(false);
    }
  }

  Future<bool> getAllBillMan()async{
    try{
      await FirebaseFirestore.instance.collection('BillMan').get().then((snapshot){
        _billManList.clear();
        snapshot.docChanges.forEach((element) {
          BillManModel billManModel = BillManModel(
              id: element.doc['id'],
              phone: element.doc['phone'],
              name: element.doc['name'],
              password: element.doc['password'],
              address: element.doc['address'],
              timeStamp: element.doc['timeStamp'],
          );
          _billManList.add(billManModel);
        });
      });
      notifyListeners();
      return Future.value(true);
    }catch(error){
      return Future.value(false);
    }
  }

  Future<bool> deleteBillMan(String id)async{
    try{
      await FirebaseFirestore.instance.collection('BillMan').doc(id).delete().then((value)async{
        await getAllBillMan().then((value) {
          showToast('BillMan deleted');
        });
        notifyListeners();
      },onError: (error){
      showToast(error.toString());
    });
      return Future.value(true);
    }catch(error){
      return Future.value(false);
    }
  }

  Future<void> updateBillMan(String id,PublicProvider publicProvider)async
  {
    FirebaseFirestore.instance.collection('BillMan').doc(id).update({
      'phone':publicProvider.billManModel.phone,
      'name':publicProvider.billManModel.name,
      'password':publicProvider.billManModel.password,
      'address':publicProvider.billManModel.address,

    }).then((value)async{
      showToast('BillMan Updated');
      getAllBillMan();
      notifyListeners();
    });
  }
}