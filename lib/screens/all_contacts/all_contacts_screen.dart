import 'package:contact_manager/model/contect_model.dart';
import 'package:contact_manager/screens/contect_details/contect_details_screen.dart';
import 'package:contact_manager/screens/update_contect/bloc/update_contact_bloc.dart';
import 'package:contact_manager/screens/update_contect/update_contect_screen.dart';
import 'package:contact_manager/widgets/common_body.dart';
import 'package:contact_manager/widgets/list_card/list_card.dart';
import 'package:flutter/material.dart';

import 'bloc/all_contact_bloc.dart';

class AllContactsScreen extends StatefulWidget {
  @override
  _AllContactsScreenState createState() => _AllContactsScreenState();
}

class _AllContactsScreenState extends State<AllContactsScreen> {
  @override
  void initState() {
    super.initState();
    allContactBloc.getContactData();
  }

  @override
  Widget build(BuildContext context) {
    var isFavourite =false;

    showAlertDialog({BuildContext context, int contactId}) {
      // set up the button
      Widget okButton = FlatButton(
        child: Text("OK"),
        onPressed: () {
          allContactBloc.deleteContact(contactId: contactId);
          Navigator.of(context).pop();
        },
      );

      Widget cancelButton = FlatButton(
        child: Text("CANCEL"),
        onPressed: () {
          Navigator.of(context).pop();
        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text("Delete Contact"),
        content: Text("Are you sure you want to delete this contact."),
        actions: [
          okButton,
          cancelButton
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    return CommonBodyStructure(
      text: 'All Contacts',
      child: Center(
        child: StreamBuilder(
            stream: allContactBloc.contactListStream,
            builder: (context, snapshotContact) {
              if (snapshotContact.hasData) {
                if(snapshotContact.data.length<1){
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.account_box, color: Colors.black,size: 50.0,),
                        Text('No Contect added yet', style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30.0
                        ),)
                      ],
                    ),
                  );
                }else{
                  return ListView.builder(
                      itemCount: snapshotContact.data.length,
                      itemBuilder: (context, index) {
                        ContactModel contactItems = snapshotContact.data[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListCard(
                            name: contactItems.name,
                            mobileNo: contactItems.mobileNo,
                            isFavourite: contactItems.favourite == "Yes"?true:false,
                            onCardTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    fullscreenDialog: true,
                                    builder: (_) => ContactDetailScreen(
                                      contactModel: contactItems,
                                    ))),
                            onEditTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    fullscreenDialog: true,
                                    builder: (_) => UpdateContactScreen(
                                      contactModel: contactItems,
                                    ))),
                            onDelete: ()=> showAlertDialog(context: context, contactId: contactItems.contactId),
                            onFavouriteTap: (){
                              isFavourite=!isFavourite;
                              print('isFavourite: $isFavourite');

                              if(isFavourite){
                                updateContactBloc.addFavouriteContact(
                                    contactId: contactItems.contactId,
                                    isFavourite: "Yes"
                                );
                              }else{
                                updateContactBloc.addFavouriteContact(
                                    contactId: contactItems.contactId,
                                    isFavourite: "No"
                                );
                              }
                            },
                          ),
                        );
                      });
                }
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            }),
      ),
    );
  }
}
