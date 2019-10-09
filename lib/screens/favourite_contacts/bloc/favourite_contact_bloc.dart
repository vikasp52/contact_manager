import 'package:contact_manager/model/contect_model.dart';
import 'package:contact_manager/util/database_helper.dart';
import 'package:rxdart/rxdart.dart';

class FavouriteContactBloc{
  final db = new DataBaseHelper();

  static final _contactListController = BehaviorSubject<List<ContactModel>>();
  Stream<List<ContactModel>> get contactListStream => _contactListController.stream;
  Function(List<ContactModel>) get contactListSink => _contactListController.sink.add;

  List<ContactModel> _contactList = <ContactModel>[];

  void getContactData() async {

    await db.getFavouriteContacts("Yes").then((data) {
      print("Data is: $data");
      _contactList = [];
      for(int i=0; i<data.length; i++){

        ContactModel contactItems = ContactModel.fromMap(data[i]);
        _contactList.add(contactItems);

        print('Contact Item: $contactItems');

      }

      data.forEach((allContact){

        ContactModel todoitems = ContactModel.fromMap(allContact);
        print('Contact Item forexch: $todoitems');

      });

    });

    contactListSink(_contactList);

    print('Contect lIst:: $_contactList');
  }


  void deleteContact({int contactId}){

    db.deleteContactItems(contactId).then((val){
      getContactData();
    });

  }



  dispose() {
    _contactListController.close();
  }

}

FavouriteContactBloc favouriteContactBloc = FavouriteContactBloc();