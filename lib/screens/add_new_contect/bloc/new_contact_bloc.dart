import 'dart:async';
import 'dart:io';
import 'package:contact_manager/screens/all_contacts/bloc/all_contact_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'package:contact_manager/model/contect_model.dart';
import 'package:contact_manager/util/database_helper.dart';
import 'package:rxdart/rxdart.dart';

class NewContactBloc{
  final db = new DataBaseHelper();
  static final _nameController = BehaviorSubject<String>();
  static final _dobController = BehaviorSubject<String>();
  static final _mobNoController = BehaviorSubject<String>();
  static final _profilePicController = BehaviorSubject<File>();


  Stream<String> get nameStream => _nameController.stream;
  Stream<String> get dobStream => _dobController.stream;
  Stream<String> get mobNoStream => _mobNoController.stream;
  Stream<File> get profilePicStream => _profilePicController.stream;

  Function(String) get nameSink => _nameController.sink.add;
  Function(String) get dobSink => _dobController.sink.add;
  Function(String) get mobNoSink => _mobNoController.sink.add;
  Function(File) get profilePicSink => _profilePicController.sink.add;

  Future uploadImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    profilePicSink(tempImage);
    print('Image path: $tempImage');
  }
  
  init(){
    _nameController.value = '';
    _dobController.value = null;
    _mobNoController.value = '';
    _profilePicController.value = null;
    
  }

  Stream<bool> get submitCheck =>
      Observable.combineLatest4(nameStream, dobStream, mobNoStream, profilePicStream,
              (n, g, a, e) {

            if ((_nameController.value != null && _nameController.value != '') &&
                _dobController.value != null &&
                (_mobNoController.value != null  && _nameController.value != '') &&
                _profilePicController.value != null) {
              return true;
            } else {
              return false;
            }
          });

  void saveContactData() async {
    ContactModel formData = ContactModel(
        _nameController.value,
      _dobController.value,
      _mobNoController.value,
      _profilePicController.value.path??'',
      'No'
        );

    print("Saved Data: $formData");

    await db.saveContactData(formData).then((data) {
      print("Saved Contact Data: $data");
      //db.getContactList();
      allContactBloc.getContactData();
    });
  }



  var validateEmptyField = StreamTransformer<String, String>.fromHandlers(
      handleData: (textField, sink){
        if(textField!=null && textField.isNotEmpty){
          sink.add(textField);
        }else{
          sink.addError('Please enter the value');
        }
      }
  );

  dispose() {
    _nameController.close();
    _dobController.close();
    _mobNoController.close();
    _profilePicController.close();
  }

}

NewContactBloc newContactBloc = NewContactBloc();