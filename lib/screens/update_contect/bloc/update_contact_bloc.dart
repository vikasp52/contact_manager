import 'dart:io';

import 'package:contact_manager/model/contect_model.dart';
import 'package:contact_manager/screens/all_contacts/bloc/all_contact_bloc.dart';
import 'package:contact_manager/screens/favourite_contacts/bloc/favourite_contact_bloc.dart';
import 'package:contact_manager/util/database_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';

class UpdateContactBloc{

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


  void updateContactData({int contactId}) async {
    ContactModel formData = ContactModel(
      _nameController.value,
      _dobController.value,
      _mobNoController.value,
      _profilePicController.value.path == null?'':_profilePicController.value.path,
      'No'
    );
    ContactModel newItemUpdated = ContactModel.fromMap({
      "name": _nameController.value,
      "dob": _dobController.value,
      "mobileNo":  _mobNoController.value,
      "profilePhotoUrl":  _profilePicController.value.path??'',
      "contactId": contactId
    });
    print("Saved Data: $formData");

    await db.updateContact(newItemUpdated).then((data) {
      print("Updated Contact Data: $data");
      allContactBloc.getContactData();
    });
  }

  Stream<bool> get submitCheck =>
      Observable.combineLatest4(nameStream, dobStream, mobNoStream, profilePicStream,
              (n, g, a, e) {

            if ((_nameController.value != null) &&
                _dobController.value != null &&
                (_mobNoController.value != null) &&
                _profilePicController.value != null) {
              return true;
            } else {
              return false;
            }
          });

  void addFavouriteContact({int contactId, String isFavourite}) async {

    await db.updateFavouriteContact(contactId: contactId, favourite: isFavourite).then((data) {
      print("Updated Contact Data: $data");
      allContactBloc.getContactData();
      favouriteContactBloc.getContactData();
    });
  }


  dispose() {
    _nameController.close();
    _dobController.close();
    _mobNoController.close();
    _profilePicController.close();
  }

}

UpdateContactBloc updateContactBloc = UpdateContactBloc();