import 'package:contact_manager/model/contect_model.dart';
import 'package:contact_manager/screens/all_contacts/bloc/all_contact_bloc.dart';
import 'package:contact_manager/screens/contect_details/contect_details_screen.dart';
import 'package:contact_manager/screens/update_contect/bloc/update_contact_bloc.dart';
import 'package:contact_manager/screens/update_contect/update_contect_screen.dart';
import 'package:contact_manager/widgets/common_body.dart';
import 'package:contact_manager/widgets/list_card/list_card.dart';
import 'package:flutter/material.dart';

import 'bloc/favourite_contact_bloc.dart';

class FavouriteContactsScreen extends StatefulWidget {
  @override
  _FavouriteContactsScreenState createState() => _FavouriteContactsScreenState();
}

class _FavouriteContactsScreenState extends State<FavouriteContactsScreen> {
  @override
  void initState() {
    super.initState();
    favouriteContactBloc.getContactData();
  }

  @override
  Widget build(BuildContext context) {
    var isFavourite =false;

    showAlertDialog({BuildContext context, int contactId}) {
      // set up the button
      Widget okButton = FlatButton(
        child: Text("OK"),
        onPressed: () {
          favouriteContactBloc.deleteContact(contactId: contactId);
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

    showFaveDeleteAlertDialog({BuildContext context, int contactId}) {
      // set up the button
      Widget okButton = FlatButton(
        child: Text("YES"),
        onPressed: () {
          updateContactBloc.addFavouriteContact(
              contactId: contactId,
              isFavourite: "No"
          );
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
        title: Text("Delete Favourite Contact"),
        content: Text("Are you sure you want to delete this favourite contact.", textAlign: TextAlign.center,),
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
      text: 'Favourite Contacts',
      child: Center(
        child: StreamBuilder(
            stream: favouriteContactBloc.contactListStream,
            builder: (context, snapshotContact) {
              if (snapshotContact.hasData) {
                if(snapshotContact.data.length<1){
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.star, color: Colors.black,size: 50.0,),
                        Text('No Favourite contect added yet', style: TextStyle(
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
                            showFavouriteButton: false,
                            //isFavourite: contactItems.favourite == "Yes"?true:false,
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
                            onFavDelete: ()=>showFaveDeleteAlertDialog(context: context, contactId: contactItems.contactId),
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
