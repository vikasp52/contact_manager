import 'package:contact_manager/model/contect_model.dart';
import 'package:contact_manager/widgets/common_body.dart';
import 'package:flutter/material.dart';

class ContactDetailScreen extends StatefulWidget {
  final ContactModel contactModel;

  const ContactDetailScreen({Key key, this.contactModel}) : super(key: key);

  @override
  _ContactDetailScreenState createState() => _ContactDetailScreenState();
}

class _ContactDetailScreenState extends State<ContactDetailScreen> {
  @override
  Widget build(BuildContext context) {

    Widget header() {
      return Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 60.0, 8.0, 8.0),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
              elevation: 15.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 90.0,
                  ),
                  Text(
                  widget.contactModel.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                      widget.contactModel.dob,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 15.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ),
          ),
          Align(
              alignment: Alignment.topCenter,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: CircleAvatar(
                        radius: 60.0,
                        backgroundColor: widget.contactModel.profilePhotoUrl == null ? Colors.black : Colors.white,
                        backgroundImage: NetworkImage('https://cdn1.iconfinder.com/data/icons/avatar-2-2/512/Casual_Man_2-512.png'),
                        child: widget.contactModel.profilePhotoUrl == null
                            ? const Icon(
                                Icons.person,
                                color: Colors.white,
                              )
                            : SizedBox()),
                  ),
                ],
              ))
        ],
      );
    }

    Widget buildContactForm() {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 10.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text('Mobile No: ${widget.contactModel.mobileNo}', style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold
                    ),),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    }

    return CommonBodyStructure(
      text: 'Contacts Details',
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            header(),
            buildContactForm(),
          ],
        ),
      ),
    );
  }
}
