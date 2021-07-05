import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:new_dish_admin_panlel/model/about_model.dart';
import 'package:new_dish_admin_panlel/model/head_model.dart';
import 'package:new_dish_admin_panlel/provider/public_provider.dart';
import 'package:new_dish_admin_panlel/widgets/form_decoration.dart';

class HeadProvider extends ChangeNotifier{
  HeadModel _headModel = HeadModel();
  AboutModel _aboutModel = AboutModel();
  List<HeadModel> _headList=[];

  HeadModel get headModel=> _headModel;
  AboutModel get aboutModel => _aboutModel;
  get headList=> _headList;

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

  Future<bool> addHeadDetails(HeadModel headModel)async{
    try{
      int timeStamp = DateTime.now().millisecondsSinceEpoch;
      await FirebaseFirestore.instance.collection('HeadDetails').doc(timeStamp.toString()).set({
        'id':timeStamp.toString(),
        'title':headModel.title,
        'name':headModel.name,
        'details':headModel.details,
        'debit':headModel.debit,
        'credit': headModel.credit,
        'month': headModel.month,
        'year': headModel.year,
      }).then((value){
        getAllHeadDetails().then((value) {
          showToast('Details Saved');
        });
      }, onError: (error) {
        showToast(error.toString());
      });
      return Future.value(true);
    }catch(error){
      return Future.value(false);
    }
  }

  Future<bool> getAllHeadDetails()async{
    try{
      await FirebaseFirestore.instance.collection('HeadDetails').get().then((snapshot){
        _headList.clear();
        snapshot.docChanges.forEach((element) {
          HeadModel headModel = HeadModel(
            id: element.doc['id'],
            title: element.doc['title'],
            name: element.doc['name'],
            details: element.doc['details'],
            debit: element.doc['debit'],
            credit: element.doc['credit'],
            month: element.doc['month'],
            year: element.doc['year']
          );
          _headList.add(headModel);
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
      int timeStamp = DateTime.now().millisecondsSinceEpoch;
      await FirebaseFirestore.instance.collection('About').doc(timeStamp.toString()).set({
        'id':timeStamp.toString(),
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

  Future<void> deleteHead(String id)async{
    await FirebaseFirestore.instance.collection('HeadDetails').doc(id).delete().then((value) async{
      await getAllHeadDetails().then((value) {
        showToast('Record deleted');
      });
    },onError: (error){
      showToast(error.toString());
    });
  }

  Future<void> updateHead(String id,PublicProvider publicProvider)async {
    FirebaseFirestore.instance.collection('HeadDetails').doc(id).update({
      'title':publicProvider.headModel.title,
      'name':publicProvider.headModel.name,
      'details':publicProvider.headModel.details,
      'debit':publicProvider.headModel.debit,
      'credit': publicProvider.headModel.credit,

    }).then((value)async{
      showToast('Record Updated');
      getAllHeadDetails();
      notifyListeners();
    });
  }

}